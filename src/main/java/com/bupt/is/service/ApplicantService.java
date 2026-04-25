package com.bupt.is.service;

import com.bupt.is.model.Applicant;
import java.util.List;

/**
 * 申请者业务接口：仅定义业务方法规范，无实现
 */
public interface ApplicantService {
    /**
     * 查看指定岗位的申请者列表（含业务校验）
     * 
     * @param jobPostingId 岗位ID
     * @return 申请者列表
     * @throws IllegalArgumentException 岗位ID为空时抛出
     */
    List<Applicant> getApplicantsByJobId(String jobPostingId);

    /**
     * 查看指定申请者的详情（含业务校验）
     * 
     * @param applicantId 申请者ID
     * @return 申请者对象（无则返回null）
     * @throws IllegalArgumentException 申请者ID为空时抛出
     */
    Applicant getApplicantById(String applicantId);
}