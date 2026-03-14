package dev.dao;

import dev.model.*;
import java.util.*;
//招聘信息DAO接口
public interface JobPostingDao {
    List<JobPosting> loadAll();
    Optional<JobPosting> findById(String id);
    void save(JobPosting job) throws Exception;
    void update(JobPosting job) throws Exception;
    void delete(String id) throws Exception;
}
