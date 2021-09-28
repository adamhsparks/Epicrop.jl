
function SEIR(;wth,
              emergence,
              onset,
              duration,
              rhlim,
              rainlim,
              H0,
              I0,
              RcA,
              RcT,
              RcOpt,
              p,
              i,
              Sx,
              a,
              RRS,
              RRG)

    # set up infday object
    infday = 0
    
    # set date formats
    emergence_day = Date.(emergence, Dates.DateFormat("yyyy-mm-dd"))
    
    final_day = emergence_day + Dates.Day(duration - 1)
    season = collect(emergence_day:Day(1):final_day)

    # convert emergence date into Julian date, sequential day in year
    emergence_doy = Dates.dayofyear(emergence_day)

    # check that the dates roughly align
    if !(emergence_day >= wth[1, "YYYYMMDD"] ||
        final_day > findmax(wth[:, "YYYYMMDD"])[1])
      error("incomplete weather data or dates do not align")
    end

    if (H0 < 0)
        error("H0 cannot be < 0, check your initial number of healthy sites")
    end

    if (I0 < 0)
      error("I0 cannot be < 0, check your initial number of infective sites")
    end     
      
    # subset weather data where date is greater than emergence
    season_wth = wth[in(season - Day(1)).(wth.YYYYMMDD), :]
    
    # output variables
    cofr = zeros(duration)
    rc = zeros(duration)
    RHCoef = zeros(duration)
    latency = zeros(duration)
    infectious = zeros(duration)
    intensity = zeros(duration)
    rsenesced = zeros(duration)
    rgrowth = zeros(duration)
    rtransfer = zeros(duration)
    infection = zeros(duration)
    diseased = zeros(duration)
    senesced = zeros(duration)
    removed = zeros(duration)
    now_infectious = zeros(duration)
    now_latent = zeros(duration)
    sites = zeros(duration)
    total_sites = zeros(duration)
    rrlex = zeros(duration)
    lat = zeros(duration)
    lon = zeros(duration)
    Rc_age = fn_Rc(RcA, 1:duration)
    Rc_temp = fn_Rc(RcT, wth[!, :TEMP])

    for d in 1:duration
      d_1 = d - 1
      
      # State calculations
      if d == 1
        # start crop growth
        sites[d] = H0
        rsenesced[d] = RRS * sites[d]
      else
        if d > i
          removed_today = infectious[infday + 1]
        else
          removed_today = 0
        end

        sites[d] = sites[d_1] + rgrowth[d_1] - infection[d_1] - rsenesced[d_1]
        rsenesced[d] = removed_today + RRS * sites[d]
        senesced[d] = senesced[d_1] + rsenesced[d_1]

        latency[d] = infection[d_1]
        latday = d - p
        latday = max(1, latday)
        now_latent[d] = sum(latency[latday:d])

        infectious[d] = rtransfer[d_1]
        infday = d - i
        infday = max(1, infday)
        now_infectious[d] = sum(infectious[infday:d])
      end
      
      if (wth[!, :RHUM][d] >= rhlim || wth[!, :RAIN][d] >= rainlim)
        RHCoef[d] = 1
      end
        
      rc[d] = RcOpt * (Rc_age[d] * Rc_temp[d] * RHCoef[d])
      diseased[d] = sum(infectious) + now_latent[d] + removed[d]
      removed[d] = sum(infectious) - now_infectious[d]

      cofr[d] = 1 - (diseased[d] / (sites[d] + diseased[d]))
      
      # initialisation of disease
      if d == onset
        infection[d] = I0
      elseif d > onset
                infection[d] = now_infectious[d] * rc[d] * (cofr[d] ^ a)
      else
        infection[d] = 0
      end

      if d >=  p
        rtransfer[d] = latency[latday]
      else
        rtransfer[d] = 0
      end

      total_sites[d] = diseased[d] + sites[d]
      rgrowth[d] = RRG * sites[d] * (1 - (total_sites[d] / Sx))
      intensity[d] = (diseased[d] - removed[d]) / (total_sites[d] - removed[d])
    end

    res = DataFrame(
            simday = 1:duration,
            dates = season,
            sites = sites,
            latent = now_latent,
            infectious = now_infectious,
            removed = removed,
            senseced = senesced,
            rateinf = infection,
            rtransfer = rtransfer,
            rgrowth = rgrowth,
            rsenesced = rsenesced,
            diseased = diseased,
            intensity = intensity,
            lat = wth[1, "LAT"],
            lon = wth[1, "LON"]
            )

    return res
  end

  function fn_Rc(Rc, x) 
    itp = LinearInterpolation(Rc[:, 1], Rc[:, 2], extrapolation_bc = 0)
    x = itp.(x)
    return x
  end
