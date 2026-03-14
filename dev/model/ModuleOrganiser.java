package dev.model;

import java.util.List;
import java.util.ArrayList;

//招聘者类
public class ModuleOrganiser extends User {
    private List<String> myPostingIds = new ArrayList<>();

    public ModuleOrganiser() { this.role = Role.ORGANISER; }
    public ModuleOrganiser(String id, String username, String passwordHash, String email) {
        super(id, username, passwordHash, Role.ORGANISER, email);
    }

    @Override public void updateProfile(Profile profile) { /* organisers may also have profile */ }
    public List<String> getMyPostingIds() { return myPostingIds; }
}
