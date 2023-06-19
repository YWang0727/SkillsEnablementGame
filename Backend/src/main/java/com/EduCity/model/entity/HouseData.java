package com.EduCity.model.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import lombok.Data;

/**
 * 
 * @TableName house_data
 */
@TableName(value ="house_data")
@Data
public class HouseData implements Serializable {
    /**
     * 
     */
    @TableId(value = "houseTypeID")
    private Long housetypeid;

    /**
     * 
     */
    @TableId(value = "level")
    private Long level;

    /**
     * 
     */
    @TableField(value = "unlockCost")
    private Long unlockcost;

    /**
     * 
     */
    @TableField(value = "prosperityGrow")
    private Long prosperitygrow;

    /**
     * 
     */
    @TableField(value = "constructionGrow")
    private Long constructiongrow;

    /**
     * 
     */
    @TableField(value = "goldGotPerDay")
    private Long goldgotperday;

    /**
     * 0-locked 1-unlock
     */
    @TableField(value = "isUnlock")
    private Integer isunlock;

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
        HouseData other = (HouseData) that;
        return (this.getHousetypeid() == null ? other.getHousetypeid() == null : this.getHousetypeid().equals(other.getHousetypeid()))
            && (this.getLevel() == null ? other.getLevel() == null : this.getLevel().equals(other.getLevel()))
            && (this.getUnlockcost() == null ? other.getUnlockcost() == null : this.getUnlockcost().equals(other.getUnlockcost()))
            && (this.getProsperitygrow() == null ? other.getProsperitygrow() == null : this.getProsperitygrow().equals(other.getProsperitygrow()))
            && (this.getConstructiongrow() == null ? other.getConstructiongrow() == null : this.getConstructiongrow().equals(other.getConstructiongrow()))
            && (this.getGoldgotperday() == null ? other.getGoldgotperday() == null : this.getGoldgotperday().equals(other.getGoldgotperday()))
            && (this.getIsunlock() == null ? other.getIsunlock() == null : this.getIsunlock().equals(other.getIsunlock()));
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((getHousetypeid() == null) ? 0 : getHousetypeid().hashCode());
        result = prime * result + ((getLevel() == null) ? 0 : getLevel().hashCode());
        result = prime * result + ((getUnlockcost() == null) ? 0 : getUnlockcost().hashCode());
        result = prime * result + ((getProsperitygrow() == null) ? 0 : getProsperitygrow().hashCode());
        result = prime * result + ((getConstructiongrow() == null) ? 0 : getConstructiongrow().hashCode());
        result = prime * result + ((getGoldgotperday() == null) ? 0 : getGoldgotperday().hashCode());
        result = prime * result + ((getIsunlock() == null) ? 0 : getIsunlock().hashCode());
        return result;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", housetypeid=").append(housetypeid);
        sb.append(", level=").append(level);
        sb.append(", unlockcost=").append(unlockcost);
        sb.append(", prosperitygrow=").append(prosperitygrow);
        sb.append(", constructiongrow=").append(constructiongrow);
        sb.append(", goldgotperday=").append(goldgotperday);
        sb.append(", isunlock=").append(isunlock);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}