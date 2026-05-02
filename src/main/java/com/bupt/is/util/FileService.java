package com.bupt.is.util;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Simple file utility for reading and writing text files.
 * All higher-level JSON conversion is handled by {@link GsonUtil}.
 */
public class FileService {

    private static final String DATA_DIR = "data";

    private FileService() {
    }

    private static Path resolvePath(String fileName) {
        Path dataDir = Paths.get(DATA_DIR);
        if (!Files.exists(dataDir)) {
            try {
                Files.createDirectories(dataDir);
            } catch (IOException e) {
                throw new RuntimeException("Failed to create data directory: " + dataDir, e);
            }
        }
        return dataDir.resolve(fileName);
    }

    public static String readFile(String fileName) {
        Path path = resolvePath(fileName);
        if (!Files.exists(path)) {
            return "[]";
        }
        try {
            return Files.readString(path, StandardCharsets.UTF_8);
        } catch (IOException e) {
            throw new RuntimeException("Failed to read file: " + path, e);
        }
    }

    public static void writeFile(String fileName, String content) {
        Path path = resolvePath(fileName);
        try {
            Files.writeString(path, content, StandardCharsets.UTF_8);
        } catch (IOException e) {
            throw new RuntimeException("Failed to write file: " + path, e);
        }
    }
}
