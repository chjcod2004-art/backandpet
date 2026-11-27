package com.backandpet.domain.user.dto;

import com.backandpet.domain.user.entity.Role;
import com.backandpet.domain.user.entity.User;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class UserResponse {

    private final Long userId;
    private final String loginId;
    private final String nickname;
    private final Role role;

    public static UserResponse from(User user) {
        return new UserResponse(
                user.getId(),
                user.getLoginId(),
                user.getNickname(),
                user.getRole()
        );
    }
}