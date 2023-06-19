package com.EduCity.model.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import lombok.Data;

/**
 * 
 * @TableName quiz
 */
@TableName(value ="quiz")
@Data
public class Quiz implements Serializable {
    /**
     * 
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 0-locked 1-unlocked
     */
    @TableField(value = "isUnlocked")
    private Integer isunlocked;

    /**
     * 
     */
    @TableField(value = "topScore")
    private Long topscore;

    /**
     * 
     */
    @TableField(value = "attempts")
    private Long attempts;

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
        Quiz other = (Quiz) that;
        return (this.getId() == null ? other.getId() == null : this.getId().equals(other.getId()))
            && (this.getIsunlocked() == null ? other.getIsunlocked() == null : this.getIsunlocked().equals(other.getIsunlocked()))
            && (this.getTopscore() == null ? other.getTopscore() == null : this.getTopscore().equals(other.getTopscore()))
            && (this.getAttempts() == null ? other.getAttempts() == null : this.getAttempts().equals(other.getAttempts()));
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((getId() == null) ? 0 : getId().hashCode());
        result = prime * result + ((getIsunlocked() == null) ? 0 : getIsunlocked().hashCode());
        result = prime * result + ((getTopscore() == null) ? 0 : getTopscore().hashCode());
        result = prime * result + ((getAttempts() == null) ? 0 : getAttempts().hashCode());
        return result;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", isunlocked=").append(isunlocked);
        sb.append(", topscore=").append(topscore);
        sb.append(", attempts=").append(attempts);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}