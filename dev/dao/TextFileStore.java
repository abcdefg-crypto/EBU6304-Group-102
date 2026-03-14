package dev.dao;

import java.io.*;
import java.util.*;
//文本文件存储类
public class TextFileStore {
    private File baseDir;
    public TextFileStore(File baseDir) { this.baseDir = baseDir; }

    public synchronized List<String> readLines(String relativePath) throws IOException {
        File f = new File(baseDir, relativePath);
        if(!f.exists()) return Collections.emptyList();
        List<String> lines = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(f))) {
            String line;
            while((line = br.readLine()) != null) lines.add(line);
        }
        return lines;
    }

    public synchronized void appendLine(String relativePath, String jsonLine) throws IOException {
        File f = new File(baseDir, relativePath);
        try (FileWriter fw = new FileWriter(f, true)) { fw.write(jsonLine + "\n"); }
    }

    public synchronized void overwrite(String relativePath, List<String> lines) throws IOException {
        File f = new File(baseDir, relativePath);
        try (FileWriter fw = new FileWriter(f, false)) {
            for(String l: lines) fw.write(l + "\n");
        }
    }
}