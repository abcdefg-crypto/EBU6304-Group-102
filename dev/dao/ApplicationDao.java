package dev.dao;

import dev.model.*;
import java.util.*;
//申请信息DAO接口
public interface ApplicationDao {
    List<Application> loadAll();
    List<Application> loadByJob(String jobId);
    List<Application> loadByApplicant(String applicantId);
    Optional<Application> findById(String id);
    void save(Application app) throws Exception;
    void update(Application app) throws Exception;
}