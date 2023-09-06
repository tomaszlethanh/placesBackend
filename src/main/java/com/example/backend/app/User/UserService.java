package com.example.backend.app.User;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    User createUser(String email, String username, String fullName, String firebaseToken) throws FirebaseAuthException {
        FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(firebaseToken);
        User user = new User(email, username, fullName, decodedToken.getUid());
        userRepository.save(user);
        return user;
    }
}
