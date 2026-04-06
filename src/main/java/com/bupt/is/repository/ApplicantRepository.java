package com.bupt.is.repository;

import com.bupt.is.model.Applicant;
import java.util.List;

public interface ApplicantRepository {
    // 根据岗位ID查询申请者
    List<Applicant> findByJobPostingId(String jobPostingId);

    // 根据申请者ID查询详情
    Applicant findById(String applicantId);
}
