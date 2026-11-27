package com.backandpet.global.config;

import com.backandpet.domain.user.entity.Role;
import com.backandpet.domain.user.entity.User;
import com.backandpet.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@Profile("local")
@RequiredArgsConstructor
public class LocalDataInitializer implements ApplicationRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(ApplicationArguments args) {
        if (!userRepository.existsByLoginId("user1")) {
            userRepository.save(User.builder()
                    .loginId("user1")
                    .password(passwordEncoder.encode("password1234"))
                    .nickname("테스트유저")
                    .role(Role.USER)
                    .build());
        }

        if (!userRepository.existsByLoginId("admin")) {
            userRepository.save(User.builder()
                    .loginId("admin")
                    .password(passwordEncoder.encode("admin1234"))
                    .nickname("관리자")
                    .role(Role.ADMIN)
                    .build());
        }
    }
}