package dev.service;

import dev.dao.*;
import dev.model.*;
import java.util.*;


public class WorkloadService {
    private AssignmentDao assignmentDao;
    public WorkloadService(AssignmentDao assignmentDao) { this.assignmentDao = assignmentDao; }

    public WorkloadSummary computeSummary() {
        WorkloadSummary s = new WorkloadSummary();
        // TODO: 统计 assignmentDao.loadAll()
        return s;
    }

    public List<String> suggestBalance() {
        // TODO: 返回建议（示例）
        return Collections.emptyList();
    }
}

