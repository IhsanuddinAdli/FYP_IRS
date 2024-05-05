package com.model;

public class Feedback {

    private int feedbackID;
    private int userID;
    private int quotationId;
    private String feedback;
    private int rating;

    public Feedback() {
    }

    public Feedback(int userID, int quotationId, String feedback, int rating) {
        this.userID = userID;
        this.quotationId = quotationId;
        this.feedback = feedback;
        this.rating = rating;
    }

    public int getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(int feedbackID) {
        this.feedbackID = feedbackID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getQuotationId() {
        return quotationId;
    }

    public void setQuotationId(int quotationId) {
        this.quotationId = quotationId;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }
}
