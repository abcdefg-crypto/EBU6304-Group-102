package dev.dao;

import dev.model.*;
import java.util.*;

public interface AssignmentDao {
    List<Assignment> loadAll();
    void save(Assignment asg) throws Exception;
}