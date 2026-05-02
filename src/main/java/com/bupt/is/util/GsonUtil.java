package com.bupt.is.util;

import com.google.gson.Gson;
import java.lang.reflect.Type;
import java.util.List;

public class GsonUtil {

    private static final Gson gson = new Gson();

    public static String toJson(Object obj) {
        return gson.toJson(obj);
    }

    public static <T> T fromJson(String json, Class<T> clazz) {
        return gson.fromJson(json, clazz);
    }

    public static <T> List<T> fromJsonList(String json, Type type) {
        return gson.fromJson(json, type);
    }
}
