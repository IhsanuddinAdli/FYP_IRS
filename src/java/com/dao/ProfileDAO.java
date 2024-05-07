package com.dao;

import com.model.Profile;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProfileDAO {

    public static void updateProfileImage(int userID, InputStream fileContent, String roles) throws SQLException, ClassNotFoundException {
        String tableName = getTableName(roles);
        String updateQuery = "UPDATE " + tableName + " SET profileIMG=? WHERE userID=?";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement preparedStatement = con.prepareStatement(updateQuery)) {
            preparedStatement.setBlob(1, fileContent);
            preparedStatement.setInt(2, userID);
            preparedStatement.executeUpdate();
        }
    }

    public static InputStream getProfileImage(int userID, String roles) throws SQLException, ClassNotFoundException {
        String tableName = getTableName(roles);
        String selectQuery = "SELECT profileIMG FROM " + tableName + " WHERE userID=?";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement preparedStatement = con.prepareStatement(selectQuery)) {
            preparedStatement.setInt(1, userID);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                return rs.getBlob("profileIMG").getBinaryStream();
            } else {
                return null;
            }
        }
    }

    public static Profile getProfileByID(int userID, String roles) throws SQLException, ClassNotFoundException {
        String tableName = getTableName(roles);
        String selectQuery = "SELECT * FROM " + tableName + " WHERE userID=?";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement preparedStatement = con.prepareStatement(selectQuery)) {
            preparedStatement.setInt(1, userID);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                Profile profile = new Profile();
                profile.setUserID(rs.getInt("userID"));
                profile.setFirstname(rs.getString("firstname"));
                profile.setLastname(rs.getString("lastname"));
                profile.setProfileImage(rs.getBinaryStream("profileIMG"));
                // Set additional attributes specific to the user role if needed
                return profile;
            } else {
                return null;
            }
        }
    }

    private static String getTableName(String roles) {
        switch (roles) {
            case "customer":
                return "customer";
            case "staff":
                return "staff";
            case "manager":
                return "manager";
            case "admin":
                return "admin";
            default:
                throw new IllegalArgumentException("Invalid user role: " + roles);
        }
    }

    public static Profile getCustomerByID(int userID) throws SQLException, ClassNotFoundException {
        Profile customer = null;
        try (Connection con = DBConnection.getConnection();
                PreparedStatement preparedStatement = con.prepareStatement("SELECT * FROM customer WHERE userID=?")) {
            preparedStatement.setInt(1, userID);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                customer = new Profile();
                customer.setUserID(rs.getInt("userID"));
                customer.setFirstname(rs.getString("firstname"));
                customer.setLastname(rs.getString("lastname"));
                customer.setProfileImage(rs.getBinaryStream("profileIMG"));
            }
        }
        return customer;
    }
}
