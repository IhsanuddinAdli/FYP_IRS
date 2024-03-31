package com.model;

public class Feedback {
    private String feedback;
    private int rating;
    private int userID;

    public String getFeedback() {
        return feedback;
    }

    public int getRating() {
        return rating;
    }

    public int getUserID() {
        return userID;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    
}
