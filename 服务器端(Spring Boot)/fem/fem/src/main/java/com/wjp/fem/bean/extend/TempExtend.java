package com.wjp.fem.bean.extend;

import com.wjp.fem.bean.Spot;
import com.wjp.fem.bean.Temperature;

public class TempExtend extends Temperature{
	private Spot spot;

	public Spot getSpot() {
		return spot;
	}

	public void setSpot(Spot spot) {
		this.spot = spot;
	}

	public TempExtend(Spot spot) {
		super();
		this.spot = spot;
	}

	public TempExtend() {
		super();
	}
	
}
