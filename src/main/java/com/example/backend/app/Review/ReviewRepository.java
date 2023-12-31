package com.example.backend.app.Review;

import com.example.backend.app.Business.Business;
import com.example.backend.app.User.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findByUser_FirebaseUid(String firebaseUid);
    List<Review> findByBusiness_FirebaseUid(String firebaseUid);
    Page<Review> findByBusiness_FirebaseUid(String firebaseUid, Pageable pageable);
    Optional<Review> findByUserAndBusiness(User user, Business business);

}
