package dev.model;

//应聘者个人信息类


public class Profile {
    private String fullName;
    private String studentId;
    private String department;
    private String contact;

    public Profile() {}
    public Profile(String fullName, String studentId, String department, String contact) {
        this.fullName = fullName; this.studentId = studentId; this.department = department; this.contact = contact;
    }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }
}