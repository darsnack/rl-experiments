function getcartlocation(env, width) :: Int
    world_width = env.x_threshold * 2
    scale = width / world_width
    floor(env.state[1] * scale + width / 2.0)  # middle of cart
end

function showenv(env, req_width)
    rgb_arr = render!(env)
    n_channels, height, width = size(rgb_arr)
    
    # squash height
    lbound :: Int = floor(height * 0.4)
    ubound :: Int = floor(height * 0.8)
    rgb_arr = rgb_arr[:, lbound:ubound, :]
    
    # squash width
#     view_width :: Int = floor(width * 0.6)
    cart_loc = getcartlocation(env._env, width)
#     if cart_loc <= view_width ÷ 2
#         w_range = 1:view_width
#     elseif cart_loc >= width - view_width ÷ 2
#         w_range = (width - view_width):width
#     else
#         w_range = (cart_loc - view_width ÷ 2):(cart_loc + view_width ÷ 2)
#     end
#     rgb_arr = rgb_arr[:, :, w_range]
            
    # convert to floating point and resize
    img = Gray.(colorview(RGB{Float64}, rgb_arr))
    ratio = req_width / min(width, length(lbound:ubound))
    img = imresize(img, ratio=ratio)
    rgb_flt = convert(Array{Float32}, channelview(img))
    rgb_flt = permutedims(rgb_flt, [2, 1])
    width, height = size(rgb_flt)
#     rgb_batch = similar(rgb_flt, eltype(rgb_flt), (width, height, 1, 1))
    rgb_batch = zeros(width, height, 1, 1)
    rgb_batch[:, :, 1, 1] = rgb_flt
    (rgb_batch |> gpu, floor(cart_loc * ratio))
end