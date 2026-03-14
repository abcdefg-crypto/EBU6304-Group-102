package dev.model;
//应聘者技能标签类
public class Skill {
    private String name;
    private int level; // 1-5

    public Skill() {}
    public Skill(String name, int level) { this.name = name; this.level = level; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getLevel() { return level; }
    public void setLevel(int level) { this.level = level; }
}