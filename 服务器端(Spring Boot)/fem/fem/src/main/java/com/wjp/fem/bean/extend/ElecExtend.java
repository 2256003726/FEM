package com.wjp.fem.bean.extend;

import com.wjp.fem.bean.Electricity;
import com.wjp.fem.bean.Spot;

public class ElecExtend extends Electricity{
	private Spot spot;

	public Spot getSpot() {
		return spot;
	}

	public void setSpot(Spot spot) {
		this.spot = spot;
	}

	public ElecExtend(Spot spot) {
		super();
		this.spot = spot;
	}

	public ElecExtend() {
		super();
	}
	
}
