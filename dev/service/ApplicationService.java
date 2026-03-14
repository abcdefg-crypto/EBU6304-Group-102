package dev.service;

import dev.model.*;
import dev.dao.*;
import java.util.*;

//
public class ApplicationService {
    private ApplicationDao applicationDao;
    private JobPostingDao jobDao;
    private MatchingService matchingService;

    public ApplicationService(ApplicationDao applicationDao, JobPostingDao jobDao, MatchingService matchingService) {
        this.applicationDao = applicationDao; this.jobDao = jobDao; this.matchingService = matchingService;
    }

    public Application submitApplication(String applicantId, String jobId, String coverLetter) throws Exception {
        // TODO: 校验是否重复 -> 计算 matchScore -> 保存
        return null;
    }

    public List<Application> getByApplicant(String applicantId) { return applicationDao.loadByApplicant(applicantId); }
}