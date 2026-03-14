package dev.util;

import java.lang.reflect.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 简易 JSON 工具类（纯 Java 实现，不依赖外部库）
 *
 * 特性：
 *  - 序列化：POJO、Map、Collection、数组、String、Number、Boolean、Date、Enum
 *  - 反序列化：将 JSON 字符串解析为 Map/List/基本类型，或将 JSON 对象映射到 POJO（基于字段名匹配）
 *  - 日期采用 ISO-8601 样式（带毫秒和 UTC：yyyy-MM-dd'T'HH:mm:ss.SSS'Z'）
 *
 * 限制：
 *  - 不支持复杂泛型的精确恢复（例如嵌套泛型类型在反序列化时可能退化为 List<Object>），但尽力尝试解析字段的泛型参数。
 *  - 反序列化要求 POJO 提供无参构造器，且字段名与 JSON 键一一对应。
 *  - 不处理循环引用（序列化时用简单策略避免无限递归）。
 */
public class JsonUtil {
    private static final String DATE_ISO_PATTERN = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    private static final TimeZone UTC = TimeZone.getTimeZone("UTC");

    /* ======================= 序列化 ======================= */

    /**
     * 将任意对象序列化为 JSON 字符串。
     * 支持：null, String, Number, Boolean, Date, Enum, Map, Collection, Array, POJO（通过反射字段读取）
     *
     * @param obj 待序列化对象
     * @return JSON 字符串
     */
    public static String toJson(Object obj) {
        StringBuilder sb = new StringBuilder();
        IdentityHashMap<Object, Boolean> visited = new IdentityHashMap<>();
        serializeValue(obj, sb, visited);
        return sb.toString();
    }

    // 序列化值的内部实现（带简单循环引用保护）
    private static void serializeValue(Object obj, StringBuilder sb, IdentityHashMap<Object, Boolean> visited) {
        if (obj == null) { sb.append("null"); return; }
        if (visited.containsKey(obj)) {
            // 简单处理循环引用：输出 null（可替换为更复杂策略）
            sb.append("null");
            return;
        }

        Class<?> cls = obj.getClass();
        if (obj instanceof String) {
            sb.append('\"').append(escapeString((String) obj)).append('\"');
        } else if (obj instanceof Number || obj instanceof Boolean) {
            sb.append(obj.toString());
        } else if (obj instanceof Date) {
            SimpleDateFormat df = new SimpleDateFormat(DATE_ISO_PATTERN);
            df.setTimeZone(UTC);
            sb.append('\"').append(df.format((Date) obj)).append('\"');
        } else if (cls.isEnum()) {
            sb.append('\"').append(((Enum<?>) obj).name()).append('\"');
        } else if (obj instanceof Map) {
            visited.put(obj, Boolean.TRUE);
            sb.append('{');
            boolean first = true;
            Map<?, ?> map = (Map<?, ?>) obj;
            for (Map.Entry<?, ?> e : map.entrySet()) {
                if (!first) sb.append(',');
                first = false;
                sb.append('\"').append(escapeString(String.valueOf(e.getKey()))).append('\"');
                sb.append(':');
                serializeValue(e.getValue(), sb, visited);
            }
            sb.append('}');
            visited.remove(obj);
        } else if (obj instanceof Collection) {
            visited.put(obj, Boolean.TRUE);
            sb.append('[');
            boolean first = true;
            for (Object item : (Collection<?>) obj) {
                if (!first) sb.append(',');
                first = false;
                serializeValue(item, sb, visited);
            }
            sb.append(']');
            visited.remove(obj);
        } else if (cls.isArray()) {
            visited.put(obj, Boolean.TRUE);
            sb.append('[');
            int len = Array.getLength(obj);
            for (int i = 0; i < len; i++) {
                if (i > 0) sb.append(',');
                serializeValue(Array.get(obj, i), sb, visited);
            }
            sb.append(']');
            visited.remove(obj);
        } else {
            // POJO：反射读取字段（包含父类字段），忽略 static/transient
            visited.put(obj, Boolean.TRUE);
            sb.append('{');
            boolean first = true;
            Class<?> curr = cls;
            while (curr != null && curr != Object.class) {
                Field[] fields = curr.getDeclaredFields();
                for (Field f : fields) {
                    int mod = f.getModifiers();
                    if (Modifier.isStatic(mod) || Modifier.isTransient(mod)) continue;
                    f.setAccessible(true);
                    Object val;
                    try { val = f.get(obj); } catch (IllegalAccessException e) { continue; }
                    if (!first) sb.append(',');
                    first = false;
                    sb.append('\"').append(escapeString(f.getName())).append('\"').append(':');
                    serializeValue(val, sb, visited);
                }
                curr = curr.getSuperclass();
            }
            sb.append('}');
            visited.remove(obj);
        }
    }

    // 字符串转义（符合 JSON 要求）
    private static String escapeString(String s) {
        StringBuilder sb = new StringBuilder();
        for (char c : s.toCharArray()) {
            switch (c) {
                case '\"': sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\b': sb.append("\\b"); break;
                case '\f': sb.append("\\f"); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                default:
                    if (c < 0x20 || c > 0x7F) {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else sb.append(c);
            }
        }
        return sb.toString();
    }

    /* ======================= 反序列化（解析） ======================= */

    /**
     * 将 JSON 字符串解析为目标类型对象。
     * 支持将 JSON 对象映射为 POJO（字段名匹配）、List/Map、基本类型、数组等。
     *
     * @param json  JSON 字符串
     * @param clazz 目标类型 Class
     * @param <T>   目标类型
     * @return 解析后的对象（解析失败返回 null）
     */
    public static <T> T fromJson(String json, Class<T> clazz) {
        if (json == null || json.trim().isEmpty()) return null;
        JsonParser parser = new JsonParser(json);
        Object parsed = parser.parseValue();
        return convertToType(parsed, clazz, null);
    }

    // 将解析后的通用对象（Map/List/String/Number/Boolean/null）转换为指定类型
    @SuppressWarnings("unchecked")
    private static <T> T convertToType(Object parsed, Class<T> clazz, Type genericType) {
        if (parsed == null) return null;
        if (clazz.isAssignableFrom(parsed.getClass())) return (T) parsed;

        if (clazz == String.class) return (T) String.valueOf(parsed);
        if (clazz == Integer.class || clazz == int.class) return (T) (Integer) toInteger(parsed);
        if (clazz == Long.class || clazz == long.class) return (T) (Long) toLong(parsed);
        if (clazz == Double.class || clazz == double.class) return (T) (Double) toDouble(parsed);
        if (clazz == Float.class || clazz == float.class) return (T) (Float) toFloat(parsed);
        if (clazz == Boolean.class || clazz == boolean.class) return (T) (Boolean) parsed;
        if (Date.class.isAssignableFrom(clazz) && parsed instanceof String) {
            try {
                SimpleDateFormat df = new SimpleDateFormat(DATE_ISO_PATTERN);
                df.setTimeZone(UTC);
                return (T) df.parse((String) parsed);
            } catch (ParseException e) { return null; }
        }
        if (clazz.isEnum() && parsed instanceof String) {
            String name = (String) parsed;
            Object[] constants = clazz.getEnumConstants();
            for (Object c : constants) if (((Enum<?>) c).name().equals(name)) return (T) c;
        }

        if (Map.class.isAssignableFrom(clazz) && parsed instanceof Map) {
            return (T) parsed; // 原始 Map 返回（键值均为基本解析对象）
        }

        if (Collection.class.isAssignableFrom(clazz) && parsed instanceof List) {
            // 试图恢复集合（退化为 ArrayList）并尝试转换元素类型（泛型信息有限）
            List<?> src = (List<?>) parsed;
            Collection<Object> out = new ArrayList<>();
            Type elemType = null;
            if (genericType instanceof ParameterizedType) {
                Type[] args = ((ParameterizedType) genericType).getActualTypeArguments();
                if (args.length == 1) elemType = args[0];
            }
            for (Object item : src) {
                if (elemType instanceof Class) out.add(convertToType(item, (Class<?>) elemType, null));
                else out.add(item);
            }
            return (T) out;
        }

        if (clazz.isArray() && parsed instanceof List) {
            List<?> src = (List<?>) parsed;
            Class<?> comp = clazz.getComponentType();
            Object arr = Array.newInstance(comp, src.size());
            for (int i = 0; i < src.size(); i++) {
                Object val = convertToType(src.get(i), comp, null);
                Array.set(arr, i, val);
            }
            return (T) arr;
        }

        if (parsed instanceof Map) {
            // 将 Map 映射为 POJO（要求无参构造器，按字段名写入）
            Map<String, Object> map = (Map<String, Object>) parsed;
            try {
                T instance = clazz.getDeclaredConstructor().newInstance();
                Class<?> curr = clazz;
                while (curr != null && curr != Object.class) {
                    Field[] fields = curr.getDeclaredFields();
                    for (Field f : fields) {
                        int mod = f.getModifiers();
                        if (Modifier.isStatic(mod) || Modifier.isTransient(mod)) continue;
                        String name = f.getName();
                        if (!map.containsKey(name)) continue;
                        Object value = map.get(name);
                        f.setAccessible(true);
                        Type genType = f.getGenericType();
                        Object converted = convertToField(value, f.getType(), genType);
                        try { f.set(instance, converted); } catch (IllegalAccessException ignored) {}
                    }
                    curr = curr.getSuperclass();
                }
                return instance;
            } catch (Exception e) {
                return null;
            }
        }

        return null;
    }

    // 将单个字段值转换为字段所需类型（支持集合/数组/POJO/基础类型/枚举/日期）
    private static Object convertToField(Object value, Class<?> fieldType, Type genericType) {
        if (value == null) return null;
        if (fieldType.isAssignableFrom(value.getClass())) return value;
        if (fieldType == String.class) return String.valueOf(value);
        if (fieldType == Integer.class || fieldType == int.class) return toInteger(value);
        if (fieldType == Long.class || fieldType == long.class) return toLong(value);
        if (fieldType == Double.class || fieldType == double.class) return toDouble(value);
        if (fieldType == Float.class || fieldType == float.class) return toFloat(value);
        if (fieldType == Boolean.class || fieldType == boolean.class) return (Boolean) value;
        if (Date.class.isAssignableFrom(fieldType) && value instanceof String) {
            try { SimpleDateFormat df = new SimpleDateFormat(DATE_ISO_PATTERN); df.setTimeZone(UTC); return df.parse((String) value); } catch (Exception e) { return null; }
        }
        if (fieldType.isEnum() && value instanceof String) {
            String s = (String) value;
            Object[] consts = fieldType.getEnumConstants();
            for (Object c : consts) if (((Enum<?>) c).name().equals(s)) return c;
        }
        if (Collection.class.isAssignableFrom(fieldType) && value instanceof List) {
            List<?> src = (List<?>) value;
            Collection<Object> out = new ArrayList<>();
            Type elemType = null;
            if (genericType instanceof ParameterizedType) {
                Type[] args = ((ParameterizedType) genericType).getActualTypeArguments();
                if (args.length == 1) elemType = args[0];
            }
            for (Object item : src) {
                if (elemType instanceof Class) out.add(convertToType(item, (Class<?>) elemType, null));
                else out.add(item);
            }
            return out;
        }
        if (fieldType.isArray() && value instanceof List) {
            List<?> src = (List<?>) value;
            Class<?> comp = fieldType.getComponentType();
            Object arr = Array.newInstance(comp, src.size());
            for (int i = 0; i < src.size(); i++) Array.set(arr, i, convertToType(src.get(i), comp, null));
            return arr;
        }
        if (value instanceof Map) {
            return convertToType(value, fieldType, genericType);
        }
        return null;
    }

    // 基本数字转换辅助
    private static Integer toInteger(Object v) {
        if (v instanceof Number) return ((Number) v).intValue();
        try { return Integer.parseInt(String.valueOf(v)); } catch (Exception e) { return null; }
    }
    private static Long toLong(Object v) {
        if (v instanceof Number) return ((Number) v).longValue();
        try { return Long.parseLong(String.valueOf(v)); } catch (Exception e) { return null; }
    }
    private static Double toDouble(Object v) {
        if (v instanceof Number) return ((Number) v).doubleValue();
        try { return Double.parseDouble(String.valueOf(v)); } catch (Exception e) { return null; }
    }
    private static Float toFloat(Object v) {
        if (v instanceof Number) return ((Number) v).floatValue();
        try { return Float.parseFloat(String.valueOf(v)); } catch (Exception e) { return null; }
    }

    /* ======================= 简单 JSON 解析器 ======================= */

    // 内部轻量解析器：将 JSON 文本解析为 Map/List/String/Number/Boolean/null 的组合结构
    private static class JsonParser {
        private final String s;
        private int pos = 0;
        public JsonParser(String s) { this.s = s; }

        public Object parseValue() {
            skipWhitespace();
            if (pos >= s.length()) return null;
            char c = s.charAt(pos);
            if (c == '{') return parseObject();
            if (c == '[') return parseArray();
            if (c == '\"') return parseString();
            if (c == 't' || c == 'f' || c == 'n') return parseLiteral();
            return parseNumber();
        }

        private Map<String,Object> parseObject() {
            Map<String,Object> map = new LinkedHashMap<>();
            expect('{');
            skipWhitespace();
            if (peek() == '}') { pos++; return map; }
            while (true) {
                skipWhitespace();
                String key = parseString();
                skipWhitespace();
                expect(':');
                skipWhitespace();
                Object val = parseValue();
                map.put(key, val);
                skipWhitespace();
                char c = peek();
                if (c == ',') { pos++; continue; }
                if (c == '}') { pos++; break; }
                throw new RuntimeException("Unexpected char in object: " + c + " at " + pos);
            }
            return map;
        }

        private List<Object> parseArray() {
            List<Object> list = new ArrayList<>();
            expect('[');
            skipWhitespace();
            if (peek() == ']') { pos++; return list; }
            while (true) {
                skipWhitespace();
                Object v = parseValue();
                list.add(v);
                skipWhitespace();
                char c = peek();
                if (c == ',') { pos++; continue; }
                if (c == ']') { pos++; break; }
                throw new RuntimeException("Unexpected char in array: " + c + " at " + pos);
            }
            return list;
        }

        private String parseString() {
            expect('\"');
            StringBuilder sb = new StringBuilder();
            while (pos < s.length()) {
                char c = s.charAt(pos++);
                if (c == '\"') break;
                if (c == '\\') {
                    if (pos >= s.length()) break;
                    char esc = s.charAt(pos++);
                    switch (esc) {
                        case '\"': sb.append('\"'); break;
                        case '\\': sb.append('\\'); break;
                        case '/': sb.append('/'); break;
                        case 'b': sb.append('\b'); break;
                        case 'f': sb.append('\f'); break;
                        case 'n': sb.append('\n'); break;
                        case 'r': sb.append('\r'); break;
                        case 't': sb.append('\t'); break;
                        case 'u':
                            String hex = s.substring(pos, pos+4);
                            pos += 4;
                            sb.append((char) Integer.parseInt(hex, 16));
                            break;
                        default: sb.append(esc); break;
                    }
                } else sb.append(c);
            }
            return sb.toString();
        }

        private Object parseLiteral() {
            if (matchAhead("true")) { pos += 4; return Boolean.TRUE; }
            if (matchAhead("false")) { pos += 5; return Boolean.FALSE; }
            if (matchAhead("null")) { pos += 4; return null; }
            throw new RuntimeException("Unexpected literal at " + pos);
        }

        private Number parseNumber() {
            int start = pos;
            if (peek() == '-') pos++;
            while (pos < s.length() && Character.isDigit(peek())) pos++;
            boolean isDouble = false;
            if (peek() == '.') { isDouble = true; pos++; while (pos < s.length() && Character.isDigit(peek())) pos++; }
            if (peek() == 'e' || peek() == 'E') { isDouble = true; pos++; if (peek()=='+'||peek()=='-') pos++; while (pos < s.length() && Character.isDigit(peek())) pos++; }
            String num = s.substring(start, pos);
            try {
                if (isDouble) return Double.parseDouble(num);
                else {
                    try { return Long.parseLong(num); } catch (NumberFormatException e) { return Double.parseDouble(num); }
                }
            } catch (NumberFormatException e) { throw new RuntimeException("Invalid number at " + start + ": " + num); }
        }

        private void skipWhitespace() { while (pos < s.length() && Character.isWhitespace(s.charAt(pos))) pos++; }
        private char peek() { if (pos >= s.length()) return '\0'; return s.charAt(pos); }
        private void expect(char c) { if (pos >= s.length() || s.charAt(pos) != c) throw new RuntimeException("Expected '"+c+"' at " + pos); pos++; }
        private boolean matchAhead(String t) { return s.regionMatches(pos, t, 0, t.length()); }
    }

}