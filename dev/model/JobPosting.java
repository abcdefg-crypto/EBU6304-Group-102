package dev.model;

import java.util.*;

//招聘信息类
public class JobPosting {
    private String id;
    private String title;
    private String moduleCode;
    private String description;
    private List<SkillRequirement> requirements = new ArrayList<>();
    private int requiredTACount;
    private Date startDate;
    private Date endDate;
    private List<String> applicationIds = new ArrayList<>();

    public JobPosting() {}

    // getters/setters omitted for brevity in skeleton
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getModuleCode() { return moduleCode; }
    public void setModuleCode(String moduleCode) { this.moduleCode = moduleCode; }
    public List<SkillRequirement> getRequirements() { return requirements; }
    public void setRequirements(List<SkillRequirement> requirements) { this.requirements = requirements; }
    public int getRequiredTACount() { return requiredTACount; }
    public void setRequiredTACount(int requiredTACount) { this.requiredTACount = requiredTACount; }
}

//技能要求类
class SkillRequirement {
    private String skillName;
    private int minLevel;
    private boolean required;

    public SkillRequirement() {}
    public SkillRequirement(String skillName, int minLevel, boolean required) { this.skillName = skillName; this.minLevel = minLevel; this.required = required; }
    public String getSkillName() { return skillName; }
    public void setSkillName(String skillName) { this.skillName = skillName; }
    public int getMinLevel() { return minLevel; }
    public void setMinLevel(int minLevel) { this.minLevel = minLevel; }
    public boolean isRequired() { return required; }
    public void setRequired(boolean required) { this.required = required; }
}



