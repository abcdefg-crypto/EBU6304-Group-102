// ==================== service/MatchingService.java ====================
package dev.service;

import dev.model.*;
import java.util.*;

public class MatchingService {
    public double computeMatchScore(Applicant a, JobPosting job) {
        // TODO: 实现加权匹配算法，返回 0..100
        return 0.0;
    }

    public List<Applicant> recommendCandidates(JobPosting job, int topN, List<Applicant> pool) {
        // TODO: 对候选人排序并返回 topN
        return Collections.emptyList();
    }
}

