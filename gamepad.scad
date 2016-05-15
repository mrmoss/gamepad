walls=3;
wall_wiggle=0.5;
epsilon=0.01;
big_epsilon=1;
js_yoff=-30;
js_to_wall_yoff=4;
js_radius=25/2;
js_board_side=39;
dist_between_js=35;
js_walls=3;
box_zoff=0;
heights=[3,21.5,3];
button_spacing=25;
button_radius_1=6;
button_radius_2=8;
button_inset=heights[2]-1;
button_z_subtraction=8;
dist_between_dpad=90;
dpad_yoff=5;
dpad_to_wall_yoff=2;
dpad_terminal_inset=1.5;
dpad_terminal_r=3;
dpad_terminal_hole_wiggle=0.5;
dist_between_handles=130;
handles_yoff=-40;
handles_zoff=30;
handle_length=60;
handle_xrot=35;
handle_zrot=30;
pwr_switch_size=[12,4.5];
pwr_switch_yoff=10;
usb_yoff=31.5;
usb_zoff=1;
usb_size=[9,walls+big_epsilon*2,heights[2]+1];
usb_border=3;
usb_inset=2;
screw_hole_r=2.5/2;
screw_walls=2;
screw_head_r=4;
screw_countersink=1.5;
$fn=80;

module handle(dir=1)
{
    rotate(handle_zrot*dir)
        scale([1,1,0.75])
            hull()
            {
                big=30;
                small=20;
                translate([0,handle_length/2,0])
                    sphere(r=big);
                translate([0,-handle_length/2,0])
                    sphere(r=small);
            }
}

module handles()
{
    difference()
    {
        rotate([handle_xrot,0,0])
            translate([0,0,handles_zoff])
            {
                translate([dist_between_handles/2,handles_yoff,0])
                    handle(1);
                translate([-dist_between_handles/2,handles_yoff,0])
                    handle(-1);
            }
        top(0);
    }
}

module dpad(radius)
{
    translate([-button_spacing/2,0,0])
        circle(r=radius);
    translate([button_spacing/2,0,0])
        circle(r=radius);
    translate([0,button_spacing/2,0])
        circle(r=radius);
    translate([0,-button_spacing/2,0])
        circle(r=radius);
}

module dpads()
{
    translate([0,dpad_to_wall_yoff])
    {
        translate([-dist_between_dpad/2,dpad_yoff])
            dpad(button_radius_1);
        translate([dist_between_dpad/2,dpad_yoff])
            rotate(45)
                dpad(button_radius_1);
    }
}

module insides()
{
    hull()
    {
        real_dist_between_js=dist_between_js+js_radius*2;
        w=js_board_side;
        translate([-(real_dist_between_js+w)/2,js_yoff-w/2+js_to_wall_yoff])
            square(size=[w,w]);
        translate([(real_dist_between_js-w)/2,js_yoff-w/2+js_to_wall_yoff])
            square(size=[w,w]);
        translate([dist_between_dpad/2,dpad_yoff])
            circle(r=25);
        translate([-dist_between_dpad/2,dpad_yoff])
            circle(r=25);
    }
}

module top_holes()
{
    real_dist_between_js=dist_between_js+js_radius*2;
    translate([-real_dist_between_js/2,js_yoff+js_to_wall_yoff])
        circle(r=js_radius);
    translate([real_dist_between_js/2,js_yoff+js_to_wall_yoff])
        circle(r=js_radius);
    dpads();
    translate([-pwr_switch_size[0]/2,pwr_switch_yoff])  
        square(size=pwr_switch_size);
}

module top_insets()
{
    translate([0,dpad_to_wall_yoff])
    {
        translate([-dist_between_dpad/2,dpad_yoff])
            dpad(button_radius_2);
        translate([dist_between_dpad/2,dpad_yoff])
            rotate(45)
                dpad(button_radius_2);
    }
}

module other_holes()
{
    translate([-usb_size[0]/2,usb_yoff-usb_size[1]/2,walls+usb_zoff])
        cube(size=usb_size);
    usb_inset_size=usb_size+[usb_border*2,-usb_size[1]+usb_inset,usb_border*2];
    translate([-usb_inset_size[0]/2,usb_yoff-usb_inset_size[1]/2+(walls-usb_inset)/2+epsilon,walls+usb_zoff-usb_border])
        cube(size=usb_inset_size);
}

module middle(hollow,h_override=0,z_override=0,inset=0)
{
    translate([0,0,z_override])
        linear_extrude(height=heights[1]+h_override)
            difference()
            {
                difference()
                {
                    offset(walls-inset)
                        insides();
                    if(hollow!=0)
                        offset(inset)
                            insides();
                }
            }
}

module screw_terminal(countersink=0,long=0)
{
    difference()
    {
        if(countersink==0)
            translate([0,0,heights[0]])
                cylinder(r=screw_walls+screw_hole_r,h=heights[1]-heights[0]);
        union()
        {
            translate([0,0,-epsilon])
            {
                cylinder(r=screw_hole_r,h=heights[1]+epsilon*2);
                if(countersink!=0)
                    translate([0,0,-long])
                        cylinder(r=screw_head_r,h=screw_countersink+epsilon*2+long);
            }
        }
    }
}

module screw_terminals(bottom=0,long=0)
{
    xoff0=20;
    yoff0=20;
    translate([-xoff0,yoff0,0])
        screw_terminal(bottom,long);
    translate([xoff0,yoff0,0])
        screw_terminal(bottom,long);
    xoff1=54;
    yoff1=-20;
    translate([-xoff1,yoff1,0])
        screw_terminal(bottom,long);
    translate([xoff1,yoff1,0])
        screw_terminal(bottom,long);
}

module dpad_terminals(hole=0)
{
    translate([0,0,heights[0]-dpad_terminal_inset])
        linear_extrude(height=dpad_terminal_inset-heights[0]+heights[1]-button_z_subtraction)
            offset(-button_radius_1+dpad_terminal_r+hole*dpad_terminal_hole_wiggle)
                dpads();
}

module face(holes)
{
        difference()
        {
            linear_extrude(height=heights[2])
                offset(walls)
                    insides();
            if(holes!=0)
            {
                union()
                {
                    giant_epsilon=2;
                    translate([0,0,-giant_epsilon])
                        linear_extrude(height=heights[2]+giant_epsilon*2)
                            top_holes();
                    linear_extrude(height=button_inset)
                        top_insets();
                }
            }
        }
}

module top(hollow=1)
{
    translate([0,0,box_zoff])
        difference()
        {
            union()
            {
                face(0,walls);
                middle(hollow);
                translate([0,0,heights[1]-epsilon])
                    //if(hollow==0) //debug: uncomment to hide top face
                        face(hollow);
            }
            other_holes();
        }
}

module gamepad(part=0)
{
    if(part==0)
    {
        difference()
        {
            union()
            {
                handles();
                top();
            }
            middle(0,30,-31,walls+epsilon);
            cutw=250;
            cuth=200;
            cutz=100;
            translate([-cutw/2,-cuth/2,heights[1]+heights[2]])
                cube(size=[cutw,cuth,cutz]);
        }
        screw_terminals(0);
    }
    else if(part==1)
    {
        difference()
        {
            intersection()
            {
                union()
                {
                    handles();
                    top();
                }
                middle(0,30,-31,walls+epsilon+wall_wiggle);
            }
            screw_terminals(1,20);
            dpad_terminals(1);
        }
    }
}

gamepad(0);
//gamepad(1);
//dpad_terminals();