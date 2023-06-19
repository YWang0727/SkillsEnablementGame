package com.EduCity.model.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import lombok.Data;

/**
 * 
 * @TableName construction_speed_level
 */
@TableName(value ="construction_speed_level")
@Data
public class ConstructionSpeedLevel implements Serializable {
    /**
     * 
     */
    @TableId(value = "level")
    private Long level;

    /**
     * 
     */
    @TableField(value = "upgradeTime")
    private Long upgradetime;

    /**
     * 
     */
    @TableField(value = "buildTime")
    private Long buildtime;

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
        ConstructionSpeedLevel other = (ConstructionSpeedLevel) that;
        return (this.getLevel() == null ? other.getLevel() == null : this.getLevel().equals(other.getLevel()))
            && (this.getUpgradetime() == null ? other.getUpgradetime() == null : this.getUpgradetime().equals(other.getUpgradetime()))
            && (this.getBuildtime() == null ? other.getBuildtime() == null : this.getBuildtime().equals(other.getBuildtime()));
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((getLevel() == null) ? 0 : getLevel().hashCode());
        result = prime * result + ((getUpgradetime() == null) ? 0 : getUpgradetime().hashCode());
        result = prime * result + ((getBuildtime() == null) ? 0 : getBuildtime().hashCode());
        return result;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", level=").append(level);
        sb.append(", upgradetime=").append(upgradetime);
        sb.append(", buildtime=").append(buildtime);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}