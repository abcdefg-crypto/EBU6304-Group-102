package com.bupt.is.repository.impl;
import com.bupt.is.model.Applicant;
import com.bupt.is.repository.ApplicantRepository;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Repository实现层：仅负责File IO实现，严格遵循接口规范
 */
public class ApplicantFileRepositoryImpl implements ApplicantRepository {
    private static final String DATA_FILE = "data/applicants.dat";

    @Override
    public List<Applicant> findByJobPostingId(String jobPostingId) {
        return findAll().stream()
                .filter(applicant -> jobPostingId.equals(applicant.getJobPostingId()))
                .collect(Collectors.toList());
    }

    @Override
    public Applicant findById(String applicantId) {
        return findAll().stream()
                .filter(applicant -> applicantId.equals(applicant.getApplicantId()))
                .findFirst()
                .orElse(null);
    }

    // 私有辅助方法：读取所有申请者数据（仅实现层内部使用）
    @SuppressWarnings("unchecked")
    private List<Applicant> findAll() {
        File file = new File(DATA_FILE);
        if (!file.exists())
            return new ArrayList<>();

        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(file))) {
            return (List<Applicant>) ois.readObject();
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}