package com.bupt.is.service.impl;

import com.bupt.is.model.Applicant;
import com.bupt.is.repository.ApplicantRepository;
import com.bupt.is.repository.impl.ApplicantFileRepositoryImpl;
import com.bupt.is.service.ApplicantService;
import java.util.List;

/**
 * 申请者业务实现类：处理业务规则，依赖Repository接口
 */
public class ApplicantServiceImpl implements ApplicantService {
    // 依赖Repository接口（面向接口编程，便于替换实现）
    private final ApplicantRepository applicantRepository;

    // 构造方法：默认使用文件实现（也可通过构造注入替换）
    public ApplicantServiceImpl() {
        this.applicantRepository = new ApplicantFileRepositoryImpl();
    }

    @Override
    public List<Applicant> getApplicantsByJobId(String jobPostingId) {
        // 业务校验：岗位ID非空
        if (jobPostingId == null || jobPostingId.trim().isEmpty()) {
            throw new IllegalArgumentException("岗位ID不能为空");
        }
        // 调用Repository获取数据（无额外业务逻辑）
        return applicantRepository.findByJobPostingId(jobPostingId);
    }

    @Override
    public Applicant getApplicantById(String applicantId) {
        // 业务校验：申请者ID非空
        if (applicantId == null || applicantId.trim().isEmpty()) {
            throw new IllegalArgumentException("申请者ID不能为空");
        }
        // 调用Repository获取数据
        return applicantRepository.findById(applicantId);
    }
}