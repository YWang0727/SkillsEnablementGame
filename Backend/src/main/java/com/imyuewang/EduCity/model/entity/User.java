package com.imyuewang.EduCity.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Arrays;
import lombok.Data;

/**
 * 
 * @TableName user
 */
@TableName(value ="user")
@Data
public class User implements Serializable {
    /**
     * 
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 
     */
    @TableField(value = "email")
    private String email;

    /**
     * 
     */
    @TableField(value = "password")
    private String password;

    /**
     * 
     */
    @TableField(value = "name")
    private String name;

    /**
     * 
     */
    @TableField(value = "cityMap")
    private Long cityMap;

    /**
     * 0-not actived 1-actived
     */
    @TableField(value = "isFirst")
    private Integer isFirst;

    /**
     * 
     */
    @TableField(value = "activeCode")
    private String activeCode;

    /**
     * 
     */
    @TableField(value = "avatar")
    private byte[] avatar;

    @TableField(value = "logoutTime")
    private Timestamp logoutTime;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;

    @Override
    public boolean equals(Object that) {
        if (this == that) {
            return true;
        }
        if (that == null) {
            return false;
        }
        if (getClass() != that.getClass()) {
            return false;
        }
        User other = (User) that;
        return (this.getId() == null ? other.getId() == null : this.getId().equals(other.getId()))
            && (this.getEmail() == null ? other.getEmail() == null : this.getEmail().equals(other.getEmail()))
            && (this.getPassword() == null ? other.getPassword() == null : this.getPassword().equals(other.getPassword()))
            && (this.getName() == null ? other.getName() == null : this.getName().equals(other.getName()))
            && (this.getCityMap() == null ? other.getCityMap() == null : this.getCityMap().equals(other.getCityMap()))
            && (this.getIsFirst() == null ? other.getIsFirst() == null : this.getIsFirst().equals(other.getIsFirst()))
            && (this.getActiveCode() == null ? other.getActiveCode() == null : this.getActiveCode().equals(other.getActiveCode()))
            && (Arrays.equals(this.getAvatar(), other.getAvatar()));
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((getId() == null) ? 0 : getId().hashCode());
        result = prime * result + ((getEmail() == null) ? 0 : getEmail().hashCode());
        result = prime * result + ((getPassword() == null) ? 0 : getPassword().hashCode());
        result = prime * result + ((getName() == null) ? 0 : getName().hashCode());
        result = prime * result + ((getCityMap() == null) ? 0 : getCityMap().hashCode());
        result = prime * result + ((getIsFirst() == null) ? 0 : getIsFirst().hashCode());
        result = prime * result + ((getActiveCode() == null) ? 0 : getActiveCode().hashCode());
        result = prime * result + (Arrays.hashCode(getAvatar()));
        return result;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", email=").append(email);
        sb.append(", password=").append(password);
        sb.append(", name=").append(name);
        sb.append(", citymap=").append(cityMap);
        sb.append(", isFirst=").append(isFirst);
        sb.append(", activecode=").append(activeCode);
        sb.append(", avatar=").append(avatar);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}