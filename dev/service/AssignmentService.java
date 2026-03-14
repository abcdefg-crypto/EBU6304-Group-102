// ==================== service/AssignmentService.java ====================
package dev.service;

import dev.model.*;
import dev.dao.*;
import java.util.*;

public class AssignmentService {
    private AssignmentDao assignmentDao;
    private ApplicationDao applicationDao;

    public AssignmentService(AssignmentDao assignmentDao, ApplicationDao applicationDao) { this.assignmentDao = assignmentDao; this.applicationDao = applicationDao; }

    public List<Assignment> autoAssign(JobPosting job, List<Applicant> candidates) throws Exception {
        // TODO: 按 matchScore 和 currentLoad 平衡分配
        return Collections.emptyList();
    }

    public void manualAssign(String jobId, String applicantId) throws Exception {
        // TODO: 手动分配并持久化 Assignment
    }
}

