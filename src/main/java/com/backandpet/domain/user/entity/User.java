package com.backandpet.domain.user.entity;

import com.backandpet.global.common.BaseTimeEntity;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "users")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class User extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long id;

    @Column(name = "login_id", nullable = false, unique = true, length = 50)
    private String loginId;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "nickname", nullable = false, length = 30)
    private String nickname;

    @Enumerated(EnumType.STRING)
    @Column(name = "role", nullable = false, length = 20)
    private Role role;

    @Column(name = "github_username", length = 50)
    private String githubUsername;

    @Column(name = "github_token", length = 512)
    private String githubToken;

    @Builder
    public User(String loginId, String password, String nickname, Role role) {
        this.loginId = loginId;
        this.password = password;
        this.nickname = nickname;
        this.role = (role != null) ? role : Role.USER;
    }

    public void connectGithub(String githubUsername, String encryptedToken) {
        this.githubUsername = githubUsername;
        this.githubToken = encryptedToken;
    }

    public void changeRole(Role newRole) {
        this.role = newRole;
    }
}