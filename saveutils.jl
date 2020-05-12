function save_model(model, prefix)
    m = cpu(model)
    w = weights = Tracker.data.(params(m))
    @save "$(prefix)-model.bson" m
    @save "$(prefix)-weights.bson" w
end

function load_model(prefix)
    @load "$(prefix)-model.bson" m
    @load "$(prefix)-weights.bson" w
    Flux.loadparams!(m, w)
    return m
end