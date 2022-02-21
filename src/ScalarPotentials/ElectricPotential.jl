"""
    struct ElectricPotential{T, N, S, AT} <: AbstractArray{T, N}
        
Electric potential of the simulation in units of volt (V).
        
## Parametric types 
* `T`: Element type of `data`.
* `N`: Dimension of the `grid` and `data` array.  
* `S`: Coordinate system (`Cartesian` or `Cylindrical`).
* `AT`: Axes type.  
        
## Fields
* `data::Array{T, N}`: Array containing the values of the electric potential at the discrete points of the `grid`.
* `grid::Grid{T, N, S, AT}`: [`Grid`](@ref) defining the discrete points for which the electric potential is determined.
"""
struct ElectricPotential{T, N, S, AT} <: AbstractArray{T, N}
    data::Array{T, N}
    grid::Grid{T, N, S, AT}
end

@inline size(epot::ElectricPotential{T, N, S}) where {T, N, S} = size(epot.data)
@inline length(epot::ElectricPotential{T, N, S}) where {T, N, S} = length(epot.data)
@inline getindex(epot::ElectricPotential{T, N, S}, I::Vararg{Int, N}) where {T, N, S} = getindex(epot.data, I...)
@inline getindex(epot::ElectricPotential{T, N, S}, i::Int) where {T, N, S} = getindex(epot.data, i)
@inline getindex(epot::ElectricPotential{T, N, S}, s::Symbol) where {T, N, S} = getindex(epot.grid, s)


function NamedTuple(epot::ElectricPotential{T, 3}) where {T}
    return (
        grid = NamedTuple(epot.grid),
        values = epot.data * u"V",
    )
end
Base.convert(T::Type{NamedTuple}, x::ElectricPotential) = T(x)
    
function ElectricPotential(nt::NamedTuple)
    grid = Grid(nt.grid)
    T = typeof(ustrip(nt.values[1]))
    S = get_coordinate_system(grid)
    N = get_number_of_dimensions(grid)
    ElectricPotential{T, N, S, typeof(grid.axes)}( ustrip.(uconvert.(u"V", nt.values)), grid)
end
Base.convert(T::Type{ElectricPotential}, x::NamedTuple) = T(x)