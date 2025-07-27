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
      $xx_acc[3:0] =
                   #ship == 0 ?
                      ((8'sd24 <= $xx_p && $xx_p <=  8'sd60) && *cyc_cnt <= 29) ? -4'sd2 :
                      ((-8'sd60 <= $xx_p && $xx_p <=  -8'sd24) && *cyc_cnt <= 29) ? 4'sd2 :
                      //((8'sd24 <= $xx_p && $xx_p <=  8'sd60) && *cyc_cnt <= 60) ? -4'sd4 :
                      //((-8'sd60 <= $xx_p && $xx_p <=  -8'sd24) && *cyc_cnt <= 60) ? 4'sd2 :
                      //(*cyc_cnt >= 60 && $xx_v != 6'b0 && ~(-8'sd24 >= $xx_p && $xx_p <= 8'sd24)) ? -4'sd2 :
                      *cyc_cnt <= 80 ? 4'd0 :
                         ( (*cyc_cnt % 80) == 12  ?  4'sd4 :
                           (*cyc_cnt % 80) == 13  ?  4'sd4 :
                           (*cyc_cnt % 80) == 17  ? -4'sd4 :
                           (*cyc_cnt % 80) == 18  ? -4'sd4 :
                           (*cyc_cnt % 80) == 19  ? -4'sd4 :
                           (*cyc_cnt % 80) == 24  ?  4'sd4 :
                           (*cyc_cnt % 80) == 32  ?  4'sd1 :
                           (*cyc_cnt % 80) == 33  ?  4'sd4 :
                           (*cyc_cnt % 80) == 44  ? -4'sd4 :
                           (*cyc_cnt % 80) == 45  ? -4'sd1 :
                           (*cyc_cnt % 80) == 47  ? -4'sd4 :
                           (*cyc_cnt % 80) == 56  ?  4'sd4 :
                           (*cyc_cnt % 80) == 57  ?  4'sd4 :
                           (*cyc_cnt % 80) == 58  ?  4'sd4 :
                           (*cyc_cnt % 80) == 61  ? -4'sd4 :
                           (*cyc_cnt % 80) == 62  ? -4'sd4 :
                           (*cyc_cnt % 80) == 66  ? -4'sd4 :
                           (*cyc_cnt % 80) == 67  ? -4'sd2 :
                           (*cyc_cnt % 80) == 78  ?  4'sd3 :
                           (*cyc_cnt % 80) == 79  ?  4'sd3 :
                                                   4'd0//-$xx_v
                         ) :
                   /*#ship == 0 ?
                      *cyc_cnt == 2 ? ($xx_p >  8'sd40)  ? (4'sd7)  :
                                      ($xx_p < -8'sd40)  ? (-4'sd7) :
                                      4'sd0 :
                      *cyc_cnt == 30 ?($xx_p >  8'sd40)  ? (4'sd2)  :
                                      ($xx_p < -8'sd40)  ? (-4'sd2) :
                                      4'sd0 :
                      4'sd0 :*/
                   #ship == 1 ?
                      *cyc_cnt == 50 ? 4'sd4:     //2 izq a der
                      *cyc_cnt == 70 ? -4'sd4:    //2 izq a der
                      *cyc_cnt == 200 ? -4'sd4:   //4 der a izq
                      *cyc_cnt == 220 ? 4'sd4:    //4 der a izq
                      *cyc_cnt == 350 ? 4'sd4:    //7 izq a der
                      *cyc_cnt == 370 ? -4'sd4:   //7 izq a der
                      *cyc_cnt == 490 ? -4'sd4:   //9 der a izq
                      *cyc_cnt == 510 ? 4'sd4:    //9 der a izq
                      *cyc_cnt == 530 ? 4'sd4:   //10 centro
                      *cyc_cnt == 540 ? -4'sd4:    //10 centro
                      4'sd0 :
                   #ship == 2 ?
                      ((8'sd24 <= $xx_p && $xx_p <=  8'sd60) && *cyc_cnt <= 29) ? -4'sd2 :
                      ((-8'sd60 <= $xx_p && $xx_p <=  -8'sd24) && *cyc_cnt <= 29) ? 4'sd2 :
                      (*cyc_cnt[2] == 1'b0) ? 4'sd2 :
                      -4'sd2 :
                   4'sd0 ;
      
      $yy_acc[3:0] =
                   #ship == 0 ?
                      ((8'sd24 <= $yy_p && $yy_p <=  8'sd60) && *cyc_cnt <= 29) ? -4'sd2 :
                      ((-8'sd60 <= $yy_p && $yy_p <=  -8'sd24) && *cyc_cnt <= 29) ? 4'sd2 :
                      *cyc_cnt >= 80 ?
                         ( (*cyc_cnt % 80) == 0  ?  4'sd4 :
                           (*cyc_cnt % 80) == 1  ?  4'sd2 :
                           (*cyc_cnt % 80) == 7  ?  4'sd2 :
                           (*cyc_cnt % 80) == 12  ? -4'sd4 :
                           (*cyc_cnt % 80) == 13  ? -4'sd4 :
                           (*cyc_cnt % 80) == 14  ? -4'sd4 :
                           (*cyc_cnt % 80) == 15  ? -4'sd2 :
                           (*cyc_cnt % 80) == 18  ?  4'sd2 :
                           (*cyc_cnt % 80) == 28  ?  -4'sd4 :
                           (*cyc_cnt % 80) == 32  ?   4'sd4 :
                           (*cyc_cnt % 80) == 33  ?   4'sd4 :
                           (*cyc_cnt % 80) == 44  ?   4'sd3 :
                           (*cyc_cnt % 80) == 47  ?   4'sd1 :
                           (*cyc_cnt % 80) == 57  ?   4'sd4 :
                           (*cyc_cnt % 80) == 60  ?  -4'sd4 :
                           (*cyc_cnt % 80) == 61  ?  -4'sd4 :
                           (*cyc_cnt % 80) == 62  ?  -4'sd4 :
                           (*cyc_cnt % 80) == 63  ?  -4'sd4 :
                           (*cyc_cnt % 80) == 67  ?   4'sd4 :
                           (*cyc_cnt % 80) == 75  ?   4'sd4 :
                           (*cyc_cnt % 80) == 76  ?   4'sd2 :
                           (*cyc_cnt % 80) == 78  ?  -4'sd1 :
                           (*cyc_cnt % 80) == 79  ?  -4'sd1 :
                                                    4'sd0
                         ) :
                      4'sd0 :
                   #ship == 1 ?
                      *cyc_cnt == 15 ? -4'sd4:   //1 bajar un poco
                      *cyc_cnt == 25 ? 4'sd4:    //1 bajar un poco
                      *cyc_cnt == 120 ? 4'sd4:   //3 subir
                      *cyc_cnt == 144 ? -4'sd4:  //3 subir
                      *cyc_cnt == 260 ? -4'sd4:   //5 bajar
                      *cyc_cnt == 284 ?  4'sd4:  //5 bajar
                      *cyc_cnt == 320 ? 4'sd4:   //6 subir
                      *cyc_cnt == 344 ? -4'sd4:  //6 subir
                      *cyc_cnt == 450 ? -4'sd4:   //8 bajar
                      *cyc_cnt == 474 ?  4'sd4:  //8 bajar
                      *cyc_cnt == 530 ? 4'sd4:   //10 centro
                      *cyc_cnt == 542 ? -4'sd4:    //10 centro
                      4'sd0 :
                   #ship == 2 ?
                      
                    ((8'sd24 <= $yy_p && $yy_p <=  8'sd60) && *cyc_cnt <= 29) ? -4'sd3:
                      ((-8'sd60 <= $yy_p && $yy_p <=  -8'sd24) && *cyc_cnt <= 29) ? 4'sd3 :
                      (*cyc_cnt[1:0] == 0 || *cyc_cnt[1:0] == 1) ? 4'sd3 :
                       4'sd0 :
                   4'sd0 ;
                   

      
      $fire_dir[1:0] =
                     #ship == 0 ?
                        *cyc_cnt == 14 ? (2'd1) :
                        *cyc_cnt == 15 ? (2'd2) :
                        *cyc_cnt == 16 ? (2'd2) :
                        *cyc_cnt >= 80 ?
                        ((*cyc_cnt % 80) == 14  ?  2'd1 :
                         (*cyc_cnt % 80) == 16  ?  2'd1 :
                         (*cyc_cnt % 80) == 18  ?  2'd2 :
                         (*cyc_cnt % 80) == 19  ?  2'd3 :
                         (*cyc_cnt % 80) == 24  ?  2'd3 :
                         (*cyc_cnt % 80) == 30  ?  2'd3 :
                         (*cyc_cnt % 80) == 32  ?  2'd3 :
                         (*cyc_cnt % 80) == 36  ?  2'd3 :
                         (*cyc_cnt % 80) == 43  ?  2'd3 :
                         (*cyc_cnt % 80) == 45  ?  2'd2 :
                         (*cyc_cnt % 80) == 46  ?  2'd3 :
                         (*cyc_cnt % 80) == 50  ?  2'd3 :
                         (*cyc_cnt % 80) == 56  ?  2'd2 :
                         (*cyc_cnt % 80) == 57  ?  2'd1 :
                         (*cyc_cnt % 80) == 58  ?  2'd3 :
                         (*cyc_cnt % 80) == 61  ?  2'd1 :
                         (*cyc_cnt % 80) == 62  ?  2'd2 :
                         (*cyc_cnt % 80) == 63  ?  2'd3 :
                         (*cyc_cnt % 80) == 65  ?  2'd2 :
                         (*cyc_cnt % 80) == 70  ?  2'd1 :
                         (*cyc_cnt % 80) == 75  ?  2'd3 :
                         (*cyc_cnt % 80) == 77  ?  2'd3 :
                                                   2'd0
                        ) :
                        //en arreglo -> jacobo
                        //(*cyc_cnt >= 16 && */(*enemy_ship[*]$xx_p <= $xx_p + 8'sd5 && *enemy_ship[*]$xx_p >= $xx_p - 8'sd5 /*&& $enemy_destroyed == 1'b0*/) && (*enemy_ship[*]$yy_p >= $yy_p && *enemy_ship[*]$yy_p <= 8'sd60 )) ? 2'd0 :
                        /_top/enemy_ship[0]$xx_p == $xx_p ? 2'd3 :
                        /_top/enemy_ship[1]$xx_p == $xx_p ? 2'd3 :
                        /_top/enemy_ship[2]$xx_p == $xx_p ? 2'd3 :
                        (*cyc_cnt >= 17 && (/_top/enemy_ship[0]$yy_p <= 8'sd60 && $yy_p < /_top/enemy_ship[0]$yy_p)) ? 2'd3 :
                        (*cyc_cnt >= 17 && (/_top/enemy_ship[0]$yy_p <= 8'sd60 && $yy_p >= -8'sd60 && $yy_p > /_top/enemy_ship[0]$yy_p)) ? 2'd3 :
                        
                        (*cyc_cnt >= 17 && (/_top/enemy_ship[0]$xx_p <= $xx_p + 8'sd6 && /_top/enemy_ship[0]$xx_p >= $xx_p - 8'sd6 && ~ /_top/enemy_ship[0]$destroyed) && (/_top/enemy_ship[0]$yy_p < $yy_p && /_top/enemy_ship[0]$yy_p <= 8'sd60 )) ? 2'd3 :
                        (*cyc_cnt >= 17 && (/_top/enemy_ship[0]$xx_p <= $xx_p + 8'sd6 && /_top/enemy_ship[0]$xx_p >= $xx_p - 8'sd6 && ~ /_top/enemy_ship[0]$destroyed) && (/_top/enemy_ship[0]$yy_p < $yy_p && /_top/enemy_ship[0]$yy_p >= -8'sd60)) ? 2'd1 :
                        (*cyc_cnt >= 17 && (/_top/enemy_ship[0]$yy_p <= $yy_p + 8'sd6 && /_top/enemy_ship[0]$yy_p >= $yy_p - 8'sd6 && ~ /_top/enemy_ship[0]$destroyed) && (/_top/enemy_ship[0]$xx_p > $xx_p && /_top/enemy_ship[0]$xx_p <= 8'sd60)) ? 2'd0 :
                        (*cyc_cnt >= 17 && (/_top/enemy_ship[0]$yy_p <= $yy_p + 8'sd6 && /_top/enemy_ship[0]$yy_p >= $yy_p - 8'sd6 && ~ /_top/enemy_ship[0]$destroyed) && (/_top/enemy_ship[0]$xx_p < $xx_p && /_top/enemy_ship[0]$xx_p >= -8'sd60)) ? 2'd2 :
                        *cyc_cnt == 24 ? (2'd3) :
                        2'd0 :
                     #ship == 1 ?
                        *cyc_cnt > 4 && *cyc_cnt < 25  && (!/_top/enemy_ship[0]$destroyed && \$signed(/_top/enemy_ship[2]$yy_p) >= -40) ? 2'd3:
                        *cyc_cnt > 4 && *cyc_cnt < 25  && (!/_top/enemy_ship[1]$destroyed && \$signed(/_top/enemy_ship[2]$yy_p) >= -40) ? 2'd3:
                        *cyc_cnt > 4 && *cyc_cnt < 25  && (!/_top/enemy_ship[2]$destroyed && \$signed(/_top/enemy_ship[1]$yy_p) >= -40) ? 2'd3:
                        *cyc_cnt >= 40 && *cyc_cnt < 100 ? 2'd3:     //1 UP
                        *cyc_cnt >= 100 && *cyc_cnt < 190 ? 2'd2:    //2 LEFT
                        *cyc_cnt >= 190 && *cyc_cnt < 250? 2'd1:    //3 DOWN
                        *cyc_cnt >= 250 && *cyc_cnt < 330? 2'd0:    //4 RIGHT
                        *cyc_cnt >= 330 && *cyc_cnt < 440? 2'd1:    //5 DOWN
                        *cyc_cnt >= 440 && *cyc_cnt < 480? 2'd2:    //6 LEFT
                        *cyc_cnt >= 480 && *cyc_cnt < 542? 2'd3:    //7 UP
                        *cyc_cnt >= 542 && (/_top/enemy_ship[0]$xx_p == $xx_p && /_top/enemy_ship[0]$yy_p > $yy_p)  || (/_top/enemy_ship[1]$xx_p == $xx_p && /_top/enemy_ship[1]$yy_p > $yy_p) || (/_top/enemy_ship[2]$xx_p == $xx_p && /_top/enemy_ship[2]$yy_p > $yy_p) ? 2'd3:
                        *cyc_cnt >= 542 && (/_top/enemy_ship[0]$xx_p == $xx_p && /_top/enemy_ship[0]$yy_p < $yy_p)  || (/_top/enemy_ship[1]$xx_p == $xx_p && /_top/enemy_ship[1]$yy_p < $yy_p) || (/_top/enemy_ship[2]$xx_p == $xx_p && /_top/enemy_ship[2]$yy_p < $yy_p) ? 2'd1:
                        *cyc_cnt >= 542 && (/_top/enemy_ship[0]$xx_p > $xx_p && /_top/enemy_ship[0]$yy_p == $yy_p)  || (/_top/enemy_ship[1]$xx_p > $xx_p && /_top/enemy_ship[1]$yy_p == $yy_p) || (/_top/enemy_ship[2]$xx_p > $xx_p && /_top/enemy_ship[2]$yy_p == $yy_p) ? 2'd0:
                        *cyc_cnt >= 542 && (/_top/enemy_ship[0]$xx_p < $xx_p && /_top/enemy_ship[0]$yy_p == $yy_p)  || (/_top/enemy_ship[1]$xx_p < $xx_p && /_top/enemy_ship[1]$yy_p == $yy_p) || (/_top/enemy_ship[2]$xx_p < $xx_p && /_top/enemy_ship[2]$yy_p == $yy_p) ? 2'd2: 
                        *cyc_cnt >= 542 && (!/_top/enemy_ship[0]$destroyed) && (/_top/enemy_ship[0]$yy_p > $yy_p) ? 2'd3: 
                        *cyc_cnt >= 542 && (!/_top/enemy_ship[1]$destroyed) && (/_top/enemy_ship[1]$xx_p < $xx_p) ? 2'd2:   
                        *cyc_cnt >= 542 && (!/_top/enemy_ship[2]$destroyed) && (/_top/enemy_ship[2]$yy_p < $yy_p) ? 2'd1:                       
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
                     /*
                        *cyc_cnt == 14 ? (1'b1) :
                        *cyc_cnt == 15 ? (1'b1) :
                        *cyc_cnt == 16 ? (1'b1) :*/
                        *cyc_cnt >= 80 ?
                         ( (*cyc_cnt % 80) == 7  ?  1'd1 :
                           (*cyc_cnt % 80) == 8  ?  1'd1 :
                           (*cyc_cnt % 80) == 13  ?  1'd1 :
                           (*cyc_cnt % 80) == 14  ?  1'd1 :
                           (*cyc_cnt % 80) == 16  ?  1'd1 :
                           (*cyc_cnt % 80) == 18  ?  1'd1 :
                           (*cyc_cnt % 80) == 19  ?  1'd1 :
                           (*cyc_cnt % 80) == 24  ?  1'd1 :
                           (*cyc_cnt % 80) == 25  ?  1'd1 :
                           (*cyc_cnt % 80) == 30  ?  1'd1 :
                           (*cyc_cnt % 80) == 32  ?  1'd1 :
                           (*cyc_cnt % 80) == 36  ?  1'd1 :
                           (*cyc_cnt % 80) == 43  ?  1'd1 :
                           (*cyc_cnt % 80) == 45  ?  1'd1 :
                           (*cyc_cnt % 80) == 46  ?  1'd1 :
                           (*cyc_cnt % 80) == 50  ?  1'd1 :
                           (*cyc_cnt % 80) == 55  ?  1'd1 :
                           (*cyc_cnt % 80) == 56  ?  1'd1 :
                           (*cyc_cnt % 80) == 57  ?  1'd1 :
                           (*cyc_cnt % 80) == 58  ?  1'd1 :
                           (*cyc_cnt % 80) == 61  ?  1'd1 :
                           (*cyc_cnt % 80) == 62  ?  1'd1 :
                           (*cyc_cnt % 80) == 63  ?  1'd1 :
                           (*cyc_cnt % 80) == 64  ?  1'd1 :
                           (*cyc_cnt % 80) == 65  ?  1'd1 :
                           (*cyc_cnt % 80) == 70  ?  1'd1 :
                           (*cyc_cnt % 80) == 75  ?  1'd1 :
                           (*cyc_cnt % 80) == 77  ?  1'd1 :
                                                     1'd0
                         ) :
                        (*cyc_cnt >= 18 && (>>1$fire_dir != $fire_dir)) ? 1'b1 :
                        (>>1$attempt_fire == 1'b1) && (>>2$attempt_fire == 1'b0) ? 1'b1 :
                        1'b0 :
                     #ship == 1 ?
                        *cyc_cnt >= 2 ? 1'b1 :
                        *cyc_cnt >= 24 && *cyc_cnt <= 30 && $energy >= 40 ? (1'b0):
                        *cyc_cnt >= 69 && *cyc_cnt <= 74 && $energy >= 40 ? (1'b0):
                        *cyc_cnt >= 143 && *cyc_cnt <= 148 && $energy >= 40 ? (1'b0):
                        *cyc_cnt >= 218 && *cyc_cnt <= 223 && $energy >= 40 ? (1'b0):
                        *cyc_cnt >= 283 && *cyc_cnt <= 288 && $energy >= 40 ? (1'b0):
                        *cyc_cnt >= 343 && *cyc_cnt <= 348 && $energy >= 40 ? (1'b0):
                        *cyc_cnt >= 369 && *cyc_cnt <= 374 && $energy >= 40 ? (1'b0):
                        *cyc_cnt >= 473 && *cyc_cnt <= 478 && $energy >= 40 ? (1'b0):
                        *cyc_cnt >= 509 && *cyc_cnt <= 514 && $energy >= 40 ? (1'b0):
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
                          //(*cyc_cnt >= 4 && >>1$attempt_shield == 1'b0) ? 1'b1 :
                          (*cyc_cnt >= 4 && *cyc_cnt <= 10) ? 1'b1 :
                          (*cyc_cnt >= 20 && *cyc_cnt <= 29) ? 1'b1 :
                          (*cyc_cnt >= 38 && *cyc_cnt <= 43) ? 1'b1 :
                          (*cyc_cnt >= 61 && *cyc_cnt <= 64) ? 1'b1 :
                          (*cyc_cnt >= 66 && *cyc_cnt <= 69) ? 1'b1 :
                          (*cyc_cnt >= 73 && *cyc_cnt <= 75) ? 1'b1 :
                          *cyc_cnt >= 80 ?
                          ((*cyc_cnt % 80) == 0  ?  1'd1 :
                           (*cyc_cnt % 80) == 2  ?  1'd1 :
                           (*cyc_cnt % 80) == 3  ?  1'd1 :
                           (*cyc_cnt % 80) == 4  ?  1'd1 :
                           (*cyc_cnt % 80) == 7  ?  1'd1 :
                           (*cyc_cnt % 80) == 8  ?  1'd1 :
                           (*cyc_cnt % 80) == 32  ?  1'd1 :
                           (*cyc_cnt % 80) == 33  ?  1'd1 :
                           (*cyc_cnt % 80) == 47  ?  1'd1 :
                           (*cyc_cnt % 80) == 48  ?  1'd1 :
                           (*cyc_cnt % 80) == 64  ?  1'd1 :
                           (*cyc_cnt % 80) == 65  ?  1'd1 :
                                                    1'd0
                          ) :
                          1'b0 :
                        #ship == 1 ?
                          (/_top/enemy_ship[0]$xx_p == $xx_p || /_top/enemy_ship[0]$yy_p == $yy_p) && $energy >= 35 ? (1'b1):
                          (/_top/enemy_ship[1]$xx_p == $xx_p || /_top/enemy_ship[1]$yy_p == $yy_p) && $energy >= 35 ? (1'b1):
                          (/_top/enemy_ship[2]$xx_p == $xx_p || /_top/enemy_ship[2]$yy_p == $yy_p) && $energy >= 35 ? (1'b1):
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
                          (*cyc_cnt == 60) ? 1'b1 :
                          *cyc_cnt >= 80 ?
                          ((*cyc_cnt % 80) == 9  ?  1'd1 :
                           (*cyc_cnt % 80) == 17  ?  1'd1 :
                           (*cyc_cnt % 80) == 24  ?  1'd1 :
                           (*cyc_cnt % 80) == 39  ?  1'd1 :
                                                    1'd0
                          ) :
                          (*cyc_cnt >= 30 && >>1$attempt_shield == 1'b1 && $xx_v >= 6'sd4) ? 1'b1 :
                          1'b0 :
                       #ship == 1 ?
                          *cyc_cnt <= 3 ? (1'b1):
                          *cyc_cnt >= 24 && *cyc_cnt <= 30 && $energy >= 25 ? (1'b1):
                          *cyc_cnt >= 69 && *cyc_cnt <= 74 && $energy >= 25 ? (1'b1):
                          *cyc_cnt >= 143 && *cyc_cnt <= 148 && $energy >= 25 ? (1'b1):
                          *cyc_cnt >= 218 && *cyc_cnt <= 223 && $energy >= 25 ? (1'b1):
                          *cyc_cnt >= 283 && *cyc_cnt <= 288 && $energy >= 25 ? (1'b1):
                          *cyc_cnt >= 343 && *cyc_cnt <= 348 && $energy >= 25 ? (1'b1):
                          *cyc_cnt >= 369 && *cyc_cnt <= 374 && $energy >= 25 ? (1'b1):
                          *cyc_cnt >= 473 && *cyc_cnt <= 478 && $energy >= 25 ? (1'b1):
                          *cyc_cnt >= 509 && *cyc_cnt <= 514 && $energy >= 25 ? (1'b1):
                          *cyc_cnt >= 539 && *cyc_cnt <= 545 && $energy >= 25 ? (1'b1):
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

//BORRAR
\TLV team_demo3(/_top)
   /ship[*]
      $xx_acc[7:0] =
         #ship == 0 ?
            (8'sd36 <= $xx_p && $xx_p <=  8'sd64) ? -4'sd4 :
            (-8'sd64 <= $xx_p && $xx_p <=  -8'sd36) ? 4'sd4 :
            4'sd0 :
         #ship == 1 ?
            (8'sd36 <= $xx_p && $xx_p <=  8'sd64) ? -4'sd4 :
            (-8'sd64 <= $xx_p && $xx_p <=  -8'sd36) ? 4'sd4 :
            4'sd0 :
         #ship == 2 ?
            *cyc_cnt == 2 ? 4'sd4 :
            (8'sd48 <= $xx_p && $xx_p <=  8'sd64) ? -4'sd4 :
            (-8'sd64 <= $xx_p && $xx_p <=  -8'sd48) ? 4'sd4 :
            4'sd0 :
         4'sd0 ;
      $fire_dir[1:0] = 2'd3;
      $attempt_fire = 1'b1;

\TLV team_demo3_viz(/_top, _team_num)
   // Visualize IOs.
   m5+io_viz_only(/_top, _team_num)

\TLV team_demo4(/_top)
   /ship[*]
      $xx_acc[7:0] =
         *cyc_cnt == 2  ? -4'sd2 :
         *cyc_cnt == 12 ?  4'sd2 :
         4'sd0 ;
      $yy_acc[7:0] =
         *cyc_cnt == 2  ? -4'sd2 :
         *cyc_cnt == 12 ?  4'sd2 :
         4'sd0 ;

\TLV team_demo4_viz(/_top, _team_num)
   // Visualize IOs.
   m5+io_viz_only(/_top, _team_num)

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
   ///m5_team(sitting_duck, Sitting Duck)
   ///m5_team(demo1, Test 1)
   ///m5_team(demo2, Test 2)
   m5_team(demo3, Demo 3)
   ///m5_team(demo4, Demo 4)
   
   
   // Instantiate the Showdown environment.
   m5+showdown(/top, /secret)
   
   *passed = /secret$passed || *cyc_cnt > 600;   // Defines max cycles, up to ~600.
   *failed = /secret$failed;
\SV
   endmodule
