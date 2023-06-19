package com.EduCity.model.vo;

import com.EduCity.model.entity.User;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;
import org.springframework.security.core.GrantedAuthority;

import java.util.Collection;

/**
 * @ClassName UserDetailsVO
 * @Description UserDetails object used for spring security
 * @Author Yue Wang
 * @Date 2023/5/4 22:44
 * @Version 1.0
 **/
@Getter
@ToString
@EqualsAndHashCode(callSuper = false)
public class UserDetailsVO extends org.springframework.security.core.userdetails.User {

    private User user;

    public UserDetailsVO(User user, Collection<? extends GrantedAuthority> authorities) {
        super(user.getEmail(), user.getPassword(), authorities);
        this.user = user;
    }

    public String getEmail() {
        return user.getEmail();
    }

}
