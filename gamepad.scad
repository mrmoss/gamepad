walls=3;
wall_wiggle=0.5;
epsilon=0.001;
js_yoff=-30;
js_to_wall_yoff=4;
js_radius=25/2;
js_board_side=39;
dist_between_js=25;
js_walls=2;
box_zoff=0;
heights=[3,21.5,3];
button_spacing=25;
button_radius=12/2;
dist_between_dpad=110;
dpad_yoff=5;
dpad_to_wall_yoff=2;
dist_between_handles=140;
handles_yoff=-40;
handles_zoff=30;
handle_length=60;
handle_xrot=35;
handle_zrot=30;
pwr_switch_size=[11.5,4.5];
pwr_switch_yoff=10;
usb_yoff=25;
usb_size=[9,10,heights[2]+1];
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

module dpad()
{
    translate([-button_spacing/2,0,0])
        circle(r=button_radius);
    translate([button_spacing/2,0,0])
        circle(r=button_radius);
    translate([0,button_spacing/2,0])
        circle(r=button_radius);
    translate([0,-button_spacing/2,0])
        circle(r=button_radius);
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
    translate([0,dpad_to_wall_yoff])
    {
        translate([-dist_between_dpad/2,dpad_yoff])
            dpad();
        translate([dist_between_dpad/2,dpad_yoff])
            rotate(45)
                dpad();
    }
    translate([-6,pwr_switch_yoff])  
        square(size=pwr_switch_size);
}

module other_holes()
{
    translate([-usb_size[0]/2,usb_yoff,walls])
        cube(size=usb_size);
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
    xoff0=35;
    yoff0=20;
    translate([-xoff0,yoff0,0])
        screw_terminal(bottom,long);
    translate([xoff0,yoff0,0])
        screw_terminal(bottom,long);
    xoff1=50;
    yoff1=-20;
    translate([-xoff1,yoff1,0])
        screw_terminal(bottom,long);
    translate([xoff1,yoff1,0])
        screw_terminal(bottom,long);
}

module face(holes)
{
    linear_extrude(height=heights[2])
        difference()
        {
            offset(walls)
                    insides();
            if(holes!=0)
                top_holes();
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
                translate([0,0,height[0]])
                {
                    middle(hollow);
                    translate([0,0,heights[1]-epsilon])
                        //if(hollow==0) //debug: uncomment to hide top face
                            face(hollow);
                }
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
        }
    }
}

//gamepad(0);
gamepad(1);