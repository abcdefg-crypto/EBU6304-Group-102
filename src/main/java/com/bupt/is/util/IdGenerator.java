package com.bupt.is.util;

public class IdGenerator {

    private IdGenerator() {
    }

    private static String withPrefix(String prefix) {
        long millis = System.currentTimeMillis();
        return prefix + millis;
    }

    public static String generateUserId() {
        return withPrefix("USER_");
    }

    public static String generateJobId() {
        return withPrefix("JOB_");
    }

    public static String generateApplicationId() {
        return withPrefix("APP_");
    }
}
