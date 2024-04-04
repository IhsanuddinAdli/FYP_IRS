package com.model;

import java.io.InputStream;

public class Customer {

    private int userID;
    private String firstname;
    private String lastname;
    private InputStream profileImage;

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public InputStream getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(InputStream profileImage) {
        this.profileImage = profileImage;
    }
}
