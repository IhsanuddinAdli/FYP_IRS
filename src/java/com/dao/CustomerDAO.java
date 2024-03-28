package com.dao;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CustomerDAO {

    public static void updateProfileImage(String userID, InputStream fileContent) throws SQLException, ClassNotFoundException {
        try (Connection con = DBConnection.getConnection();
                PreparedStatement preparedStatement = con.prepareStatement("UPDATE customer SET profileIMG=? WHERE userID=?")) {
            preparedStatement.setBlob(1, fileContent);
            preparedStatement.setString(2, userID);
            preparedStatement.executeUpdate();
        }
    }

    public static InputStream getProfileImage(String userID) throws SQLException, ClassNotFoundException {
        try (Connection con = DBConnection.getConnection();
                PreparedStatement preparedStatement = con.prepareStatement("SELECT profileIMG FROM customer WHERE userID=?")) {
            preparedStatement.setString(1, userID);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                return rs.getBlob("profile_image").getBinaryStream();
            } else {
                return null;
            }
        }
    }
}
