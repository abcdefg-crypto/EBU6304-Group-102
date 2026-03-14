
package dev.model;

import java.util.*;
//建议统计类
public class WorkloadSummary {
    private Map<String, Integer> loads = new HashMap<>();
    public WorkloadSummary() {}
    public Map<String, Integer> getLoads() { return loads; }
    public void setLoads(Map<String, Integer> loads) { this.loads = loads; }
}
