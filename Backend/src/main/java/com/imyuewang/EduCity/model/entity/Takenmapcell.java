package com.imyuewang.EduCity.model.entity;

import com.baomidou.mybatisplus.annotation.*;

import java.io.Serializable;
import lombok.Data;

/**
 * 
 * @TableName takenmapcell
 */
@TableName(value ="takenmapcell")
@Data
public class Takenmapcell implements Serializable {
    /**
     * 
     */
    @TableId(value = "mapId", type = IdType.INPUT)
    private Long mapid;

    /**
     * 
     */
    @TableField(value = "positionX")
    private Integer positionx;

    /**
     * 
     */
    @TableField(value = "positionY")
    private Integer positiony;

    /**
     * 
     */
    @TableField(value = "houseType")
    private Integer housetype;

    /**
     * 
     */
    @TableField(value = "houseLevel")
    private Integer houselevel;

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
        Takenmapcell other = (Takenmapcell) that;
        return (this.getMapid() == null ? other.getMapid() == null : this.getMapid().equals(other.getMapid()))
            && (this.getPositionx() == null ? other.getPositionx() == null : this.getPositionx().equals(other.getPositionx()))
            && (this.getPositiony() == null ? other.getPositiony() == null : this.getPositiony().equals(other.getPositiony()))
            && (this.getHousetype() == null ? other.getHousetype() == null : this.getHousetype().equals(other.getHousetype()))
            && (this.getHouselevel() == null ? other.getHouselevel() == null : this.getHouselevel().equals(other.getHouselevel()));
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((getMapid() == null) ? 0 : getMapid().hashCode());
        result = prime * result + ((getPositionx() == null) ? 0 : getPositionx().hashCode());
        result = prime * result + ((getPositiony() == null) ? 0 : getPositiony().hashCode());
        result = prime * result + ((getHousetype() == null) ? 0 : getHousetype().hashCode());
        result = prime * result + ((getHouselevel() == null) ? 0 : getHouselevel().hashCode());
        return result;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", mapid=").append(mapid);
        sb.append(", positionx=").append(positionx);
        sb.append(", positiony=").append(positiony);
        sb.append(", housetype=").append(housetype);
        sb.append(", houselevel=").append(houselevel);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}