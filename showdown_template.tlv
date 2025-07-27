\m5_TLV_version 1d: tl-x.org
\m5
   / A competition template for:
   /
   / /----------------------------------------------------------------------------\
   / | The First Annual Makerchip ASIC Design Showdown, Summer 2025, Space Battle |
   / \----------------------------------------------------------------------------/
   /
   / Each player or team modifies this template to provide their own custom spacecraft
   / control circuitry. This template is for teams using TL-Verilog. A Verilog-based
   / template is provided separately. Monitor the Showdown Slack channel for updates.
   / Use the latest template for submission.
   /
   / Just 3 steps:
   /   - Replace all YOUR_GITHUB_ID and YOUR_TEAM_NAME.
   /   - Code your logic in the module below.
   /   - Submit by Sun. July 26, 11 PM IST/1:30 PM EDT.
   /
   / Showdown details: https://www.redwoodeda.com/showdown-info and in the reposotory README.
   /
   /
   / Your circuit should drive the following signals for each of your ships, in /ship[2:0]:
   / /ships[2:0]
   /    $xx_acc[3:0], $yy_acc[3:0]: Attempted acceleration for each of your ships (if sufficient energy);
   /                                capped by max_acceleration (see showdown_lib.tlv). (use "\$signed($yy_acc) for signed math)
   /    $attempt_fire: Attempt to fire (if sufficient energy remains).
   /    $fire_dir: Direction to fire (if firing). (For the first player: 0 = right, 1 = down, 2 = left, 3 = up).
   /    $attempt_cloak: Attempted actions for each of your ships (if sufficient energy remains).
   /    $attempt_shield: Attempt to use shields (if sufficient energy remains).
   / Based on the following inputs, previous state from the enemy in /prev_enemy_ship[2:0]:
   / /ship[2:0]
   /    *clk:           Clock; used implicitly by TL-Verilog constructs, but you can use this in embedded Verilog.
   /    $reset:         Reset.
   /    $xx_p[7:0], $yy_p[7:0]: Position of your ships as affected by previous cycle's acceleration. (signed value, unsigned type)
   /    $energy[7:0]:   The energy supply of each ship, as updated by inputs last cycle.
   /    $destroyed:     Asserted if and when the ships are destroyed.
   / /enemy_ship[2:0]: Reflecting enemy input in the previous cycle.
   /    $xx_p[7:0], $yy_p[7:0]: Positions of enemy ships. (signed value, unsigned type)
   /    $cloaked: Whether the enemy ships are cloaked; if asserted enemy xx_p and xy_p did not update.
   /    $destroyed: Whether the enemy ship has been destroyed.

   / See also the game parameters in the header of `showdown_lib.tlv`.

   use(m5-1.0)
   
   var(viz_mode, devel)  /// Enables VIZ for development.
                         /// Use "devel" or "demo". ("demo" will be used in competition.)


// Modify this TL-Verilog macro to implement your control circuitry.
// Replace YOUR_GITHUB_ID with your GitHub ID, excluding non-word characters (alphabetic, numeric,
// and "_" only)
\TLV team_Jacome1005(/_top)
   /ship[*]
      $xx_acc[7:0] =
                   /*#ship == 0 ?
                      *cyc_cnt == 2 ? ($xx_p >  8'sd40)  ? (4'sd7)  :
                                      ($xx_p < -8'sd40)  ? (-4'sd7) :
                                      4'sd0 :
                      *cyc_cnt == 30 ?($xx_p >  8'sd40)  ? (4'sd2)  :
                                      ($xx_p < -8'sd40)  ? (-4'sd2) :
                                      4'sd0 :
                      4'sd0 :*/
                   #ship == 0 ?
                      ((8'sd24 <= $xx_p && $xx_p <=  8'sd60) && *cyc_cnt <= 29) ? -4'sd2 :
                      ((-8'sd60 <= $xx_p && $xx_p <=  -8'sd24) && *cyc_cnt <= 29) ? 4'sd2 :
                      ((8'sd24 <= $xx_p && $xx_p <=  8'sd60) && *cyc_cnt <= 60) ? -4'sd4 :
                      ((-8'sd60 <= $xx_p && $xx_p <=  -8'sd24) && *cyc_cnt <= 60) ? 4'sd2 :
                      (*cyc_cnt >= 60 && $xx_v != 6'b0 && ~(-8'sd24 >= $xx_p && $xx_p <= 8'sd24)) ? -4'sd2 :
                      4'sd0 :
                   #ship == 1 ?
                      *cyc_cnt >= 2 && (/_top/enemy_ship[0]$xx_p == $xx_p && ~ /_top/enemy_ship[0]$destroyed) ? (4'sd15):
                      *cyc_cnt >= 2 && (/_top/enemy_ship[1]$xx_p == $xx_p && ~ /_top/enemy_ship[1]$destroyed) ? (4'sd15):
                      *cyc_cnt >= 2 && (/_top/enemy_ship[2]$xx_p == $xx_p && ~ /_top/enemy_ship[2]$destroyed) ? (4'sd15):
                      4'sd0 :
                   #ship == 2 ?
                      ((8'sd24 <= $xx_p && $xx_p <=  8'sd60) && *cyc_cnt <= 29) ? -4'sd2 :
                      ((-8'sd60 <= $xx_p && $xx_p <=  -8'sd24) && *cyc_cnt <= 29) ? 4'sd2 :
                      (*cyc_cnt[2] == 1'b0) ? 4'sd2 :
                      -4'sd2 :
                   4'sd0 ;
      
      $yy_acc[8:0] =
                   #ship == 0 ?
                      ((8'sd24 <= $yy_p && $yy_p <=  8'sd60) && *cyc_cnt <= 29) ? -4'sd2 :
                      ((-8'sd60 <= $yy_p && $yy_p <=  -8'sd24) && *cyc_cnt <= 29) ? 4'sd2 :
                      4'sd0 :
                   #ship == 1 ?
                      *cyc_cnt >= 2 && (/_top/enemy_ship[0]$yy_p == $yy_p && ~ /_top/enemy_ship[0]$destroyed) ? (4'sd15):
                      *cyc_cnt >= 2 && (/_top/enemy_ship[1]$yy_p == $yy_p && ~ /_top/enemy_ship[1]$destroyed) ? (4'sd15):
                      *cyc_cnt >= 2 && (/_top/enemy_ship[2]$yy_p == $yy_p && ~ /_top/enemy_ship[2]$destroyed) ? (4'sd15):
                      4'sd0 :
                   #ship == 2 ?
                      ((8'sd24 <= $yy_p && $yy_p <=  8'sd60) && *cyc_cnt <= 29) ? -4'sd2 :
                      ((-8'sd60 <= $yy_p && $yy_p <=  -8'sd24) && *cyc_cnt <= 29) ? 4'sd2 :
                      (*cyc_cnt[1:0] == 0 || *cyc_cnt[1:0] == 1) ? 4'sd2 :
                      -4'sd2 :
                   4'sd0 ;

      
      $fire_dir[1:0] =
                     #ship == 0 ?
                        /*
                        *cyc_cnt == 2 ? (2'd0) :
                        *cyc_cnt == 3 ? (2'd3) :
                        *cyc_cnt == 14 ? (2'd1) :
                        *cyc_cnt == 15 ? (2'd2) :*/
                        //en arreglo -> jacobo
                        //(*cyc_cnt >= 16 && */(*enemy_ship[*]$xx_p <= $xx_p + 8'sd5 && *enemy_ship[*]$xx_p >= $xx_p - 8'sd5 /*&& $enemy_destroyed == 1'b0*/) && (*enemy_ship[*]$yy_p >= $yy_p && *enemy_ship[*]$yy_p <= 8'sd60 )) ? 2'd0 :
                        /_top/enemy_ship[0]$xx_p == $xx_p ? 2'd3 :
                        /_top/enemy_ship[1]$xx_p == $xx_p ? 2'd3 :
                        /_top/enemy_ship[2]$xx_p == $xx_p ? 2'd3 :
                        (*cyc_cnt >= 16 && (/_top/enemy_ship[0]$yy_p <= 8'sd60 && $yy_p < /_top/enemy_ship[0]$yy_p)) ? 2'd3 :
                        (*cyc_cnt >= 16 && (/_top/enemy_ship[0]$yy_p <= 8'sd60 && $yy_p >= -8'sd60 && $yy_p > /_top/enemy_ship[0]$yy_p)) ? 2'd3 :
                        
                        (*cyc_cnt >= 16 && (/_top/enemy_ship[0]$xx_p <= $xx_p + 8'sd6 && /_top/enemy_ship[0]$xx_p >= $xx_p - 8'sd6 && ~ /_top/enemy_ship[0]$destroyed) && (/_top/enemy_ship[0]$yy_p < $yy_p && /_top/enemy_ship[0]$yy_p <= 8'sd60 )) ? 2'd3 :
                        (*cyc_cnt >= 16 && (/_top/enemy_ship[0]$xx_p <= $xx_p + 8'sd6 && /_top/enemy_ship[0]$xx_p >= $xx_p - 8'sd6 && ~ /_top/enemy_ship[0]$destroyed) && (/_top/enemy_ship[0]$yy_p < $yy_p && /_top/enemy_ship[0]$yy_p >= -8'sd60)) ? 2'd1 :
                        (*cyc_cnt >= 16 && (/_top/enemy_ship[0]$yy_p <= $yy_p + 8'sd6 && /_top/enemy_ship[0]$yy_p >= $yy_p - 8'sd6 && ~ /_top/enemy_ship[0]$destroyed) && (/_top/enemy_ship[0]$xx_p > $xx_p && /_top/enemy_ship[0]$xx_p <= 8'sd60)) ? 2'd0 :
                        (*cyc_cnt >= 16 && (/_top/enemy_ship[0]$yy_p <= $yy_p + 8'sd6 && /_top/enemy_ship[0]$yy_p >= $yy_p - 8'sd6 && ~ /_top/enemy_ship[0]$destroyed) && (/_top/enemy_ship[0]$xx_p < $xx_p && /_top/enemy_ship[0]$xx_p >= -8'sd60)) ? 2'd2 :
                        
                        (*cyc_cnt >= 16 && (/_top/enemy_ship[1]$xx_p <= $xx_p + 8'sd6 && /_top/enemy_ship[1]$xx_p >= $xx_p - 8'sd6 && ~ /_top/enemy_ship[1]$destroyed) && (/_top/enemy_ship[1]$yy_p > $yy_p && /_top/enemy_ship[1]$yy_p <= 8'sd60)) ? 2'd3 :
                        (*cyc_cnt >= 16 && (/_top/enemy_ship[1]$xx_p <= $xx_p + 8'sd6 && /_top/enemy_ship[1]$xx_p >= $xx_p - 8'sd6 && ~ /_top/enemy_ship[1]$destroyed) && (/_top/enemy_ship[1]$yy_p < $yy_p && /_top/enemy_ship[1]$yy_p >= -8'sd60)) ? 2'd1 :
                        (*cyc_cnt >= 16 && (/_top/enemy_ship[1]$yy_p <= $yy_p + 8'sd6 && /_top/enemy_ship[1]$yy_p >= $yy_p - 8'sd6 && ~ /_top/enemy_ship[1]$destroyed) && (/_top/enemy_ship[1]$xx_p > $xx_p && /_top/enemy_ship[1]$xx_p <= 8'sd60)) ? 2'd0 :
                        (*cyc_cnt >= 16 && (/_top/enemy_ship[1]$yy_p <= $yy_p + 8'sd6 && /_top/enemy_ship[1]$yy_p >= $yy_p - 8'sd6 && ~ /_top/enemy_ship[1]$destroyed) && (/_top/enemy_ship[1]$xx_p < $xx_p && /_top/enemy_ship[1]$xx_p >= -8'sd60)) ? 2'd2 :
                        
                        (*cyc_cnt >= 16 && (/_top/enemy_ship[2]$xx_p <= $xx_p + 8'sd6 && /_top/enemy_ship[2]$xx_p >= $xx_p - 8'sd6 && ~ /_top/enemy_ship[2]$destroyed) && (/_top/enemy_ship[2]$yy_p > $yy_p && /_top/enemy_ship[2]$yy_p <= 8'sd60)) ? 2'd3 :
                        (*cyc_cnt >= 16 && (/_top/enemy_ship[2]$xx_p <= $xx_p + 8'sd6 && /_top/enemy_ship[2]$xx_p >= $xx_p - 8'sd6 && ~ /_top/enemy_ship[2]$destroyed) && (/_top/enemy_ship[2]$yy_p < $yy_p && /_top/enemy_ship[2]$yy_p >= -8'sd60)) ? 2'd1 :
                        (*cyc_cnt >= 16 && (/_top/enemy_ship[2]$yy_p <= $yy_p + 8'sd6 && /_top/enemy_ship[2]$yy_p >= $yy_p - 8'sd6 && ~ /_top/enemy_ship[2]$destroyed) && (/_top/enemy_ship[2]$xx_p > $xx_p && /_top/enemy_ship[2]$xx_p <= 8'sd60)) ? 2'd0 :
                        (*cyc_cnt >= 16 && (/_top/enemy_ship[2]$yy_p <= $yy_p + 8'sd6 && /_top/enemy_ship[2]$yy_p >= $yy_p - 8'sd6 && ~ /_top/enemy_ship[2]$destroyed) && (/_top/enemy_ship[2]$xx_p < $xx_p && /_top/enemy_ship[2]$xx_p >= -8'sd60)) ? 2'd2 :
                        *cyc_cnt == 24 ? (2'd3) :
                        2'd0 :
                     #ship == 1 ?
                        *cyc_cnt >= 2 && (~ /_top/enemy_ship[1]$destroyed) ? (2'd0):
                        *cyc_cnt >= 2 && (/_top/enemy_ship[1]$destroyed && ~ /_top/enemy_ship[2]$destroyed) ? (2'd3):
                        *cyc_cnt >= 2 && (/_top/enemy_ship[1]$destroyed && /_top/enemy_ship[2]$destroyed) ? (2'd0):
                        2'd0 :
                     #ship == 2 ?
   
                        //x ciclo
                        *cyc_cnt == 2 ? 2'd0 :
                        *cyc_cnt == 3 ? 2'd1 :
                        *cyc_cnt == 4 ? 2'd2 :
                        *cyc_cnt == 5 ? 2'd3 :
                        *cyc_cnt == 6 ? 2'd0 :
                        *cyc_cnt == 7 ? 2'd1 :
                         //x enemigovivo
                        (!/_top/enemy_ship[0]$destroyed &&
                           /_top/enemy_ship[0]$yy_p <= $yy_p + 8'sd5 &&
                           /_top/enemy_ship[0]$yy_p >= $yy_p - 8'sd5) ?
                              ((/_top/enemy_ship[0]$xx_p > $xx_p) ? 2'd0 : 2'd2) :
                        (!/_top/enemy_ship[0]$destroyed &&
                           /_top/enemy_ship[0]$xx_p <= $xx_p + 8'sd5 &&
                           /_top/enemy_ship[0]$xx_p >= $xx_p - 8'sd5) ?
                              ((/_top/enemy_ship[0]$yy_p > $yy_p) ? 2'd3 : 2'd1) :
                        (!/_top/enemy_ship[1]$destroyed &&
                           /_top/enemy_ship[1]$yy_p <= $yy_p + 8'sd5 &&
                           /_top/enemy_ship[1]$yy_p >= $yy_p - 8'sd5) ?
                              ((/_top/enemy_ship[1]$xx_p > $xx_p) ? 2'd0 : 2'd2) :
                        (!/_top/enemy_ship[1]$destroyed &&
                           /_top/enemy_ship[1]$xx_p <= $xx_p + 8'sd5 &&
                           /_top/enemy_ship[1]$xx_p >= $xx_p - 8'sd5) ?
                              ((/_top/enemy_ship[1]$yy_p > $yy_p) ? 2'd3 : 2'd1) :
                        (!/_top/enemy_ship[2]$destroyed &&
                           /_top/enemy_ship[2]$yy_p <= $yy_p + 8'sd5 &&
                           /_top/enemy_ship[2]$yy_p >= $yy_p - 8'sd5) ?
                              ((/_top/enemy_ship[2]$xx_p > $xx_p) ? 2'd0 : 2'd2) :
                        (!/_top/enemy_ship[2]$destroyed &&
                           /_top/enemy_ship[2]$xx_p <= $xx_p + 8'sd5 &&
                           /_top/enemy_ship[2]$xx_p >= $xx_p - 8'sd5) ?
                              ((/_top/enemy_ship[2]$yy_p > $yy_p) ? 2'd3 : 2'd1) :
                         2'd0 :
                      2'd0 ;


      
      
      $attempt_fire =
                     #ship == 0 ?
                        /*cyc_cnt == 2 ? (1'b1) :
                        *cyc_cnt == 3 ? (1'b1) :
                        *cyc_cnt == 14 ? (1'b1) :
                        *cyc_cnt == 15 ? (1'b1) :
                        */(*cyc_cnt >= 16 && (>>1$fire_dir != $fire_dir)) ? 1'b1 :
                        1'b0 :
                     #ship == 1 ?
                        (*cyc_cnt >= 5) ? 1'b1 :
                        1'b0 :
                     #ship == 2 ?
                        (*cyc_cnt >= 2 && *cyc_cnt <= 7) ? (1'b1) :
                        (
                           (>>1$fire_dir != $fire_dir) &&
                           (! /_top/enemy_ship[0]$destroyed || ! /_top/enemy_ship[1]$destroyed || ! /_top/enemy_ship[2]$destroyed)
                         ) ? 1'b1 :
                        1'b0 :
                     1'b0 ;
      
      $attempt_shield = #ship == 0 ?
                          (*cyc_cnt == 30) ? 1'b1 :
                          (*cyc_cnt >= 4 && >>1$attempt_shield == 1'b0) ? 1'b1 :
                          1'b0 :
                        #ship == 1 ?
                          *cyc_cnt >= 5 && (/_top/enemy_ship[0]$yy_p == $yy_p || /_top/enemy_ship[0]$xx_p == $xx_p) ? (1'b1):
                          *cyc_cnt >= 5 && (/_top/enemy_ship[1]$yy_p == $yy_p || /_top/enemy_ship[1]$xx_p == $xx_p) ? (1'b1):
                          *cyc_cnt >= 5 && (/_top/enemy_ship[2]$yy_p == $yy_p || /_top/enemy_ship[2]$xx_p == $xx_p) ? (1'b1):
                          1'b0 :
                        #ship == 2 ?
                          (
                           (! /_top/enemy_ship[0]$destroyed &&
                           ((/_top/enemy_ship[0]$xx_p - $xx_p)**2 + (/_top/enemy_ship[0]$yy_p - $yy_p)**2 < 8'sd36)) || (! /_top/enemy_ship[1]$destroyed &&
                           ((/_top/enemy_ship[1]$xx_p - $xx_p)**2 + (/_top/enemy_ship[1]$yy_p - $yy_p)**2 < 8'sd36)) || (! /_top/enemy_ship[2]$destroyed &&
                           ((/_top/enemy_ship[2]$xx_p - $xx_p)**2 + (/_top/enemy_ship[2]$yy_p - $yy_p)**2 < 8'sd36))) ? 1'b1 :
                          1'b0 :
                        1'b0 ;

      $attempt_cloak = #ship == 0 ?
                          (*cyc_cnt == 30) ? 1'b1 :
                          (*cyc_cnt >= 4 && >>1$attempt_shield == 1'b1 && $xx_v >= 6'sd4) ? 1'b1 :
                          1'b0 :
                       #ship == 1 ?
                          *cyc_cnt <= 5 ? (1'b1):
                          1'b0 :
                       #ship == 2 ?
                          (
                           ((! /_top/enemy_ship[0]$destroyed &&
                           ((/_top/enemy_ship[0]$xx_p - $xx_p)*2 + (/_top/enemy_ship[0]$yy_p - $yy_p)*2 < 8'd100)) ? 1 : 0) +
                           ((! /_top/enemy_ship[1]$destroyed &&
                           ((/_top/enemy_ship[1]$xx_p - $xx_p)*2 + (/_top/enemy_ship[1]$yy_p - $yy_p)*2 < 8'd100)) ? 1 : 0) +
                           ((! /_top/enemy_ship[2]$destroyed &&
                           ((/_top/enemy_ship[2]$xx_p - $xx_p)*2 + (/_top/enemy_ship[2]$yy_p - $yy_p)*2 < 8'd100)) ? 1 : 0)
                        ) >= 2 ? 1'b1 :
                        1'b0 :
                       1'b0;

      // defaults for everything else
      /*
      $xx_acc[3:0]     = 4'b0000;    // no x-accel by default  
      $yy_acc[3:0]     = 4'b0000;    // no y-accel by default  
      $attempt_fire    = 1'b0;       // never fire  
      $fire_dir[1:0]   = 2'b00;      // arbitrary default direction  
      $attempt_cloak   = 1'b0;       // never cloak  
      $attempt_shield  = 1'b0;       // never shield  
      */





// [Optional]
// Visualization of your logic for each ship.
\TLV team_Jacome1005_viz(/_top, _team_num)
   m5+io_viz(/_top, _team_num)   /// Visualization of your IOs.
   \viz_js
      m5_DefaultTeamVizBoxAndWhere()
      // Add your own visualization of your own logic here, if you like, within the bounds {left: 0..100, top: 0..100}.
      render() {
         // ... draw using fabric.js and signal values. (See VIZ docs under "LEARN" menu.)
         return [
            // For example...
            new fabric.Text('$destroyed'.asBool() ? "I''m dead! ☹️" : "I''m alive! 😊", {
               left: 10, top: 50, originY: "center", fill: "black", fontSize: 10,
            })
         ];
      },


// Compete!
// This defines the competition to simulate (for development).
// When this file is included as a library (for competition), this code is ignored.
\SV
   // Include the showdown framework.
   m4_include_lib(https://raw.githubusercontent.com/rweda/showdown-2025-space-battle/a211a27da91c5dda590feac280f067096c96e721/showdown_lib.tlv)
   
   m5_makerchip_module
\TLV
   // Enlist teams for battle.
   
   // Your team as the first. Provide:
   //   - your GitHub ID, (as in your \TLV team_* macro, above)
   //   - your team name--anything you like (that isn't crude or disrespectful)
   m5_team(Jacome1005, Verifast)
   
   // Choose your opponent.
   // Note that inactive teams must be commented with "///", not "//", to prevent M5 macro evaluation.
   ///m5_team(random, Random)
   m5_team(sitting_duck, Sitting Duck)
   ///m5_team(demo1, Test 1)
   
   
   // Instantiate the Showdown environment.
   m5+showdown(/top, /secret)
   
   *passed = /secret$passed || *cyc_cnt > 150;   // Defines max cycles, up to ~600.
   *failed = /secret$failed;
\SV
   endmodule
