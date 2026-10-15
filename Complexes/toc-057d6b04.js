// Populate the sidebar
//
// This is a script, and not included directly in the page, to control the total size of the book.
// The TOC contains an entry for each page, so if each page includes a copy of the TOC,
// the total size of the page becomes O(n**2).
class MDBookSidebarScrollbox extends HTMLElement {
    constructor() {
        super();
    }
    connectedCallback() {
        this.innerHTML = '<ol class="chapter"><li class="chapter-item "><span class="chapter-link-wrapper"><a href="index.html">Complexes</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_arithmetic_spwith_spcomplex_spmaps.html"><strong aria-hidden="true">1.</strong> arithmetic with complex maps</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_augmentation__Map.html"><strong aria-hidden="true">2.</strong> augmentationMap</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Basic_spinvariants_spand_spproperties.html"><strong aria-hidden="true">3.</strong> Basic invariants and properties</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_betti_lp__Complex_rp.html"><strong aria-hidden="true">4.</strong> betti(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_canonical__Map.html"><strong aria-hidden="true">5.</strong> canonicalMap</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_canonical__Truncation_lp__Complex_cm__Z__Z_cm__Z__Z_rp.html"><strong aria-hidden="true">6.</strong> canonicalTruncation(Complex,ZZ,ZZ)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_canonical__Truncation_lp__Complex__Map_cm__Z__Z_cm__Z__Z_rp.html"><strong aria-hidden="true">7.</strong> canonicalTruncation(ComplexMap,ZZ,ZZ)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_coimage_lp__Complex__Map_rp.html"><strong aria-hidden="true">8.</strong> coimage(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_cokernel_lp__Complex__Map_rp.html"><strong aria-hidden="true">9.</strong> cokernel(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex.html"><strong aria-hidden="true">10.</strong> Complex</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex_sp_st_st_sp__Complex.html"><strong aria-hidden="true">11.</strong> Complex ** Complex</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex_sp_st_st_sp__Matrix.html"><strong aria-hidden="true">12.</strong> Complex ** Matrix</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex_sp_eq_eq_sp__Complex.html"><strong aria-hidden="true">13.</strong> Complex == Complex</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex_sp_us_sp__Array.html"><strong aria-hidden="true">14.</strong> Complex _ Array</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex_sp_us_sp__Z__Z.html"><strong aria-hidden="true">15.</strong> Complex _ ZZ</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex_sp__Array.html"><strong aria-hidden="true">16.</strong> Complex Array</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_complex_lp__Complex_rp.html"><strong aria-hidden="true">17.</strong> complex(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_complex_lp__Complex__Map_rp.html"><strong aria-hidden="true">18.</strong> complex(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_complex_lp__Hash__Table_rp.html"><strong aria-hidden="true">19.</strong> complex(HashTable)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_complex_lp__List_rp.html"><strong aria-hidden="true">20.</strong> complex(List)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_complex_lp__Module_rp.html"><strong aria-hidden="true">21.</strong> complex(Module)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex__Map.html"><strong aria-hidden="true">22.</strong> ComplexMap</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex__Map_sp_st_sp__Complex__Map.html"><strong aria-hidden="true">23.</strong> ComplexMap * ComplexMap</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex__Map_sp_st_st_sp__Complex__Map.html"><strong aria-hidden="true">24.</strong> ComplexMap ** ComplexMap</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex__Map_sp_pl_pl_sp__Complex__Map.html"><strong aria-hidden="true">25.</strong> ComplexMap ++ ComplexMap</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex__Map_sp_eq_eq_sp__Complex__Map.html"><strong aria-hidden="true">26.</strong> ComplexMap == ComplexMap</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex__Map_sp^_sp__Array.html"><strong aria-hidden="true">27.</strong> ComplexMap ^ Array</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex__Map_sp^_sp__Z__Z.html"><strong aria-hidden="true">28.</strong> ComplexMap ^ ZZ</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex__Map_sp_us_sp__Z__Z.html"><strong aria-hidden="true">29.</strong> ComplexMap _ ZZ</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex__Map_sp_vb_sp__Complex__Map.html"><strong aria-hidden="true">30.</strong> ComplexMap | ComplexMap</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Complex__Map_sp_vb_vb_sp__Complex__Map.html"><strong aria-hidden="true">31.</strong> ComplexMap || ComplexMap</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_components_lp__Complex_rp.html"><strong aria-hidden="true">32.</strong> components(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_components_lp__Complex__Map_rp.html"><strong aria-hidden="true">33.</strong> components(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Concentration.html"><strong aria-hidden="true">34.</strong> Concentration</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_concentration.html"><strong aria-hidden="true">35.</strong> concentration</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_concentration_lp__Complex__Map_rp.html"><strong aria-hidden="true">36.</strong> concentration(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_cone_lp__Complex__Map_rp.html"><strong aria-hidden="true">37.</strong> cone(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_connecting__Ext__Map_lp__Module_cm__Matrix_cm__Matrix_rp.html"><strong aria-hidden="true">38.</strong> connectingExtMap(Module,Matrix,Matrix)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_connecting__Map_lp__Complex__Map_cm__Complex__Map_rp.html"><strong aria-hidden="true">39.</strong> connectingMap(ComplexMap,ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_connecting__Tor__Map_lp__Module_cm__Matrix_cm__Matrix_rp.html"><strong aria-hidden="true">40.</strong> connectingTorMap(Module,Matrix,Matrix)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_cylinder.html"><strong aria-hidden="true">41.</strong> cylinder</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Default_spstrategy_spfor_spfree_spresolutions_spof_sphomogeneous_spmodules.html"><strong aria-hidden="true">42.</strong> Default strategy for free resolutions of homogeneous modules</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_degree_lp__Complex__Map_rp.html"><strong aria-hidden="true">43.</strong> degree(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_differential_spof_spa_spchain_spcomplex.html"><strong aria-hidden="true">44.</strong> differential of a chain complex</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Direction.html"><strong aria-hidden="true">45.</strong> Direction</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_direct__Sum_lp__Complex_rp.html"><strong aria-hidden="true">46.</strong> directSum(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_dual_lp__Complex_rp.html"><strong aria-hidden="true">47.</strong> dual(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_dual_lp__Complex__Map_rp.html"><strong aria-hidden="true">48.</strong> dual(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Ext_lp__Module_cm__Module_rp.html"><strong aria-hidden="true">49.</strong> Ext(Module,Module)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_extend_lp__Complex_cm__Complex_cm__Matrix_cm__Sequence_rp.html"><strong aria-hidden="true">50.</strong> extend(Complex,Complex,Matrix,Sequence)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_free__Resolution.html"><strong aria-hidden="true">51.</strong> freeResolution</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_free__Resolution_lp..._cm_sp__Strategy_sp_eq_gt_sp__Engine_rp.html"><strong aria-hidden="true">52.</strong> freeResolution(..., Strategy =&gt; Engine)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_free__Resolution_lp__Complex_rp.html"><strong aria-hidden="true">53.</strong> freeResolution(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_free__Resolution_lp__Matrix_rp.html"><strong aria-hidden="true">54.</strong> freeResolution(Matrix)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_graded__Module_lp__Complex_rp.html"><strong aria-hidden="true">55.</strong> gradedModule(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___H__H_sp__Complex.html"><strong aria-hidden="true">56.</strong> HH Complex</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___H__H_sp__Complex__Map.html"><strong aria-hidden="true">57.</strong> HH ComplexMap</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___H__H_us__Z__Z_sp__Complex.html"><strong aria-hidden="true">58.</strong> HH_ZZ Complex</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Hom_lp__Complex_cm__Complex_rp.html"><strong aria-hidden="true">59.</strong> Hom(Complex,Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Hom_lp__Complex__Map_cm__Complex__Map_rp.html"><strong aria-hidden="true">60.</strong> Hom(ComplexMap,ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_homomorphism_sq_lp__Complex__Map_rp.html"><strong aria-hidden="true">61.</strong> homomorphism&#39;(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_homomorphism_lp__Complex__Map_rp.html"><strong aria-hidden="true">62.</strong> homomorphism(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_homomorphism_lp__Z__Z_cm__Matrix_cm__Complex_rp.html"><strong aria-hidden="true">63.</strong> homomorphism(ZZ,Matrix,Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_horseshoe__Resolution_lp__Complex_rp.html"><strong aria-hidden="true">64.</strong> horseshoeResolution(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_id_sp_us_sp__Complex.html"><strong aria-hidden="true">65.</strong> id _ Complex</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_image_lp__Complex__Map_rp.html"><strong aria-hidden="true">66.</strong> image(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_induced__Map_lp__Complex_cm__Complex_rp.html"><strong aria-hidden="true">67.</strong> inducedMap(Complex,Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_is__Commutative_lp__Complex__Map_rp.html"><strong aria-hidden="true">68.</strong> isCommutative(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_is__Complex__Morphism_lp__Complex__Map_rp.html"><strong aria-hidden="true">69.</strong> isComplexMorphism(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_is__Exact_lp__Complex_cm__Number_cm__Number_rp.html"><strong aria-hidden="true">70.</strong> isExact(Complex,Number,Number)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_is__Free_lp__Complex_rp.html"><strong aria-hidden="true">71.</strong> isFree(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_is__Homogeneous_lp__Complex_rp.html"><strong aria-hidden="true">72.</strong> isHomogeneous(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_is__Homogeneous_lp__Complex__Map_rp.html"><strong aria-hidden="true">73.</strong> isHomogeneous(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_is__Null__Homotopic_lp__Complex__Map_rp.html"><strong aria-hidden="true">74.</strong> isNullHomotopic(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_is__Null__Homotopy__Of_lp__Complex__Map_cm__Complex__Map_rp.html"><strong aria-hidden="true">75.</strong> isNullHomotopyOf(ComplexMap,ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_is__Quasi__Isomorphism_lp__Complex__Map_rp.html"><strong aria-hidden="true">76.</strong> isQuasiIsomorphism(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_is__Scalar.html"><strong aria-hidden="true">77.</strong> isScalar</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_is__Short__Exact__Sequence_lp__Complex_rp.html"><strong aria-hidden="true">78.</strong> isShortExactSequence(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_is__Short__Exact__Sequence_lp__Complex__Map_cm__Complex__Map_rp.html"><strong aria-hidden="true">79.</strong> isShortExactSequence(ComplexMap,ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_is__Short__Exact__Sequence_lp__Matrix_cm__Matrix_rp.html"><strong aria-hidden="true">80.</strong> isShortExactSequence(Matrix,Matrix)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_is__Well__Defined_lp__Complex_rp.html"><strong aria-hidden="true">81.</strong> isWellDefined(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_is__Well__Defined_lp__Complex__Map_rp.html"><strong aria-hidden="true">82.</strong> isWellDefined(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_kernel_lp__Complex__Map_rp.html"><strong aria-hidden="true">83.</strong> kernel(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_koszul__Complex_lp__Matrix_rp.html"><strong aria-hidden="true">84.</strong> koszulComplex(Matrix)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_length_lp__Complex_rp.html"><strong aria-hidden="true">85.</strong> length(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_lift__Map__Along__Quasi__Isomorphism_lp__Complex__Map_cm__Complex__Map_rp.html"><strong aria-hidden="true">86.</strong> liftMapAlongQuasiIsomorphism(ComplexMap,ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_long__Exact__Sequence_lp__Complex__Map_cm__Complex__Map_rp.html"><strong aria-hidden="true">87.</strong> longExactSequence(ComplexMap,ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Making_spchain_spcomplexes.html"><strong aria-hidden="true">88.</strong> Making chain complexes</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Making_spmaps_spbetween_spchain_spcomplexes.html"><strong aria-hidden="true">89.</strong> Making maps between chain complexes</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_map_lp__Complex_cm__Complex_cm__Complex__Map_rp.html"><strong aria-hidden="true">90.</strong> map(Complex,Complex,ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_map_lp__Complex_cm__Complex_cm__Function_rp.html"><strong aria-hidden="true">91.</strong> map(Complex,Complex,Function)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_map_lp__Complex_cm__Complex_cm__Hash__Table_rp.html"><strong aria-hidden="true">92.</strong> map(Complex,Complex,HashTable)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_map_lp__Complex_cm__Complex_cm__List_rp.html"><strong aria-hidden="true">93.</strong> map(Complex,Complex,List)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_map_lp__Complex_cm__Complex_cm__Z__Z_rp.html"><strong aria-hidden="true">94.</strong> map(Complex,Complex,ZZ)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_minimal__Presentation_lp__Complex_rp.html"><strong aria-hidden="true">95.</strong> minimalPresentation(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_minimize_lp__Complex_rp.html"><strong aria-hidden="true">96.</strong> minimize(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_naive__Truncation_lp__Complex_cm__Z__Z_cm__Z__Z_rp.html"><strong aria-hidden="true">97.</strong> naiveTruncation(Complex,ZZ,ZZ)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_naive__Truncation_lp__Complex__Map_cm__Z__Z_cm__Z__Z_rp.html"><strong aria-hidden="true">98.</strong> naiveTruncation(ComplexMap,ZZ,ZZ)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_null__Homotopy_lp__Complex__Map_rp.html"><strong aria-hidden="true">99.</strong> nullHomotopy(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Options_spfor_spfree_spresolutions.html"><strong aria-hidden="true">100.</strong> Options for free resolutions</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_part_lp__List_cm__Complex_rp.html"><strong aria-hidden="true">101.</strong> part(List,Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_part_lp__List_cm__Complex__Map_rp.html"><strong aria-hidden="true">102.</strong> part(List,ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_poincare_lp__Complex_rp.html"><strong aria-hidden="true">103.</strong> poincare(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_poincare__N_lp__Complex_rp.html"><strong aria-hidden="true">104.</strong> poincareN(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_prune__Complex.html"><strong aria-hidden="true">105.</strong> pruneComplex</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_prune__Complex_lp..._cm__Strategy_eq_gt..._rp.html"><strong aria-hidden="true">106.</strong> pruneComplex(...,Strategy=&gt;...)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_prune__Diff.html"><strong aria-hidden="true">107.</strong> pruneDiff</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_prune__Unit.html"><strong aria-hidden="true">108.</strong> pruneUnit</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Pruning__Map.html"><strong aria-hidden="true">109.</strong> PruningMap</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_random__Complex__Map_lp__Complex_cm__Complex_rp.html"><strong aria-hidden="true">110.</strong> randomComplexMap(Complex,Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_regularity_lp__Complex_rp.html"><strong aria-hidden="true">111.</strong> regularity(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_resolution__Map.html"><strong aria-hidden="true">112.</strong> resolutionMap</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_ring_lp__Complex_rp.html"><strong aria-hidden="true">113.</strong> ring(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Ring__Map_sp_st_st_sp__Complex.html"><strong aria-hidden="true">114.</strong> RingMap ** Complex</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Ring__Map_sp_st_st_sp__Complex__Map.html"><strong aria-hidden="true">115.</strong> RingMap ** ComplexMap</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Ring__Map_sp__Complex.html"><strong aria-hidden="true">116.</strong> RingMap Complex</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Ring__Map_sp__Complex__Map.html"><strong aria-hidden="true">117.</strong> RingMap ComplexMap</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_source_lp__Complex__Map_rp.html"><strong aria-hidden="true">118.</strong> source(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Strategies_spfor_spfree_spresolutions.html"><strong aria-hidden="true">119.</strong> Strategies for free resolutions</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Strategy_spfor_spfree_spresolutions_spof_sphomogeneous_spmodules_spaided_spby_sp__Hilbert_spfunctions.html"><strong aria-hidden="true">120.</strong> Strategy for free resolutions of homogeneous modules aided by Hilbert functions</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Strategy_spfor_spfree_spresolutions_spof_sphomogeneous_spmodules_spvia_spsuccessive_spsyzygies.html"><strong aria-hidden="true">121.</strong> Strategy for free resolutions of homogeneous modules via successive syzygies</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Strategy_spfor_spfree_spresolutions_spover_spa_spfield.html"><strong aria-hidden="true">122.</strong> Strategy for free resolutions over a field</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Strategy_spfor_spfree_spresolutions_spover_spthe_spintegers.html"><strong aria-hidden="true">123.</strong> Strategy for free resolutions over the integers</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Strategy_spfor_spfree_spresolutions_spvia_sphomogenization.html"><strong aria-hidden="true">124.</strong> Strategy for free resolutions via homogenization</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Strategy_spfor_spfree_spresolutions_spvia_sp__Schreyer-__Lascala.html"><strong aria-hidden="true">125.</strong> Strategy for free resolutions via Schreyer-Lascala</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Strategy_spfor_spfree_spresolutions_spvia_spsyzygies.html"><strong aria-hidden="true">126.</strong> Strategy for free resolutions via syzygies</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Strategy_spfor_spnonminimal_spfree_spresolutions.html"><strong aria-hidden="true">127.</strong> Strategy for nonminimal free resolutions</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_sum_lp__Complex_rp.html"><strong aria-hidden="true">128.</strong> sum(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_target_lp__Complex__Map_rp.html"><strong aria-hidden="true">129.</strong> target(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_tensor__Associativity_lp__Complex_cm__Complex_cm__Complex_rp.html"><strong aria-hidden="true">130.</strong> tensorAssociativity(Complex,Complex,Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_tensor__Commutativity_lp__Complex_cm__Complex_rp.html"><strong aria-hidden="true">131.</strong> tensorCommutativity(Complex,Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_tensor__Commutativity_lp__Module_cm__Module_rp.html"><strong aria-hidden="true">132.</strong> tensorCommutativity(Module,Module)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_to__Chain__Complex.html"><strong aria-hidden="true">133.</strong> toChainComplex</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_to__Mutable__Complex.html"><strong aria-hidden="true">134.</strong> toMutableComplex</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Tor_us__Z__Z_lp__Matrix_cm__Module_rp.html"><strong aria-hidden="true">135.</strong> Tor_ZZ(Matrix,Module)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_tor__Symmetry_lp__Z__Z_cm__Module_cm__Module_rp.html"><strong aria-hidden="true">136.</strong> torSymmetry(ZZ,Module,Module)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Towards_spcomputing_spin_spthe_spderived_spcategory.html"><strong aria-hidden="true">137.</strong> Towards computing in the derived category</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_truncate_lp__List_cm__Complex_rp.html"><strong aria-hidden="true">138.</strong> truncate(List,Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_truncate_lp__List_cm__Complex__Map_rp.html"><strong aria-hidden="true">139.</strong> truncate(List,ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Unit__Test.html"><strong aria-hidden="true">140.</strong> UnitTest</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Working_spwith_sp__Ext.html"><strong aria-hidden="true">141.</strong> Working with Ext</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="___Working_spwith_sp__Tor.html"><strong aria-hidden="true">142.</strong> Working with Tor</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_yoneda__Extension_sq_lp__Complex_rp.html"><strong aria-hidden="true">143.</strong> yonedaExtension&#39;(Complex)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_yoneda__Extension_lp__Matrix_rp.html"><strong aria-hidden="true">144.</strong> yonedaExtension(Matrix)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_yoneda__Map_sq_lp__Complex__Map_rp.html"><strong aria-hidden="true">145.</strong> yonedaMap&#39;(ComplexMap)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_yoneda__Map_lp__Matrix_rp.html"><strong aria-hidden="true">146.</strong> yonedaMap(Matrix)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_yoneda__Product_lp__Matrix_cm__Matrix_rp.html"><strong aria-hidden="true">147.</strong> yonedaProduct(Matrix,Matrix)</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="_yoneda__Product_lp__Module_cm__Module_rp.html"><strong aria-hidden="true">148.</strong> yonedaProduct(Module,Module)</a></span></li></ol>';
        // Set the current, active page, and reveal it if it's hidden
        let current_page = document.location.href.toString().split('#')[0].split('?')[0];
        if (current_page.endsWith('/')) {
            current_page += 'index.html';
        }
        const links = Array.prototype.slice.call(this.querySelectorAll('a'));
        const l = links.length;
        for (let i = 0; i < l; ++i) {
            const link = links[i];
            const href = link.getAttribute('href');
            if (href && !href.startsWith('#') && !/^(?:[a-z+]+:)?\/\//.test(href)) {
                link.href = path_to_root + href;
            }
            // The 'index' page is supposed to alias the first chapter in the book.
            // Check both with and without the '.html' suffix to be robust against pretty URLs
            if (link.href.replace(/\.html$/, '') === current_page.replace(/\.html$/, '')
                || i === 0
                && path_to_root === ''
                && current_page.endsWith('/index.html')) {
                link.classList.add('active');
                let parent = link.parentElement;
                while (parent) {
                    if (parent.tagName === 'LI' && parent.classList.contains('chapter-item')) {
                        parent.classList.add('expanded');
                    }
                    parent = parent.parentElement;
                }
            }
        }
        // Track and set sidebar scroll position
        this.addEventListener('click', e => {
            if (e.target.tagName === 'A') {
                const clientRect = e.target.getBoundingClientRect();
                const sidebarRect = this.getBoundingClientRect();
                sessionStorage.setItem('sidebar-scroll-offset', clientRect.top - sidebarRect.top);
            }
        }, { passive: true });
        const sidebarScrollOffset = sessionStorage.getItem('sidebar-scroll-offset');
        sessionStorage.removeItem('sidebar-scroll-offset');
        if (sidebarScrollOffset !== null) {
            // preserve sidebar scroll position when navigating via links within sidebar
            const activeSection = this.querySelector('.active');
            if (activeSection) {
                const clientRect = activeSection.getBoundingClientRect();
                const sidebarRect = this.getBoundingClientRect();
                const currentOffset = clientRect.top - sidebarRect.top;
                this.scrollTop += currentOffset - parseFloat(sidebarScrollOffset);
            }
        } else {
            // scroll sidebar to current active section when navigating via
            // 'next/previous chapter' buttons
            const activeSection = document.querySelector('#mdbook-sidebar .active');
            if (activeSection) {
                activeSection.scrollIntoView({ block: 'center' });
            }
        }
        // Toggle buttons
        const sidebarAnchorToggles = document.querySelectorAll('.chapter-fold-toggle');
        function toggleSection(ev) {
            ev.currentTarget.parentElement.parentElement.classList.toggle('expanded');
        }
        Array.from(sidebarAnchorToggles).forEach(el => {
            el.addEventListener('click', toggleSection);
        });
    }
}
window.customElements.define('mdbook-sidebar-scrollbox', MDBookSidebarScrollbox);


// ---------------------------------------------------------------------------
// Support for dynamically adding headers to the sidebar.

(function() {
    // This is used to detect which direction the page has scrolled since the
    // last scroll event.
    let lastKnownScrollPosition = 0;
    // This is the threshold in px from the top of the screen where it will
    // consider a header the "current" header when scrolling down.
    const defaultDownThreshold = 150;
    // Same as defaultDownThreshold, except when scrolling up.
    const defaultUpThreshold = 300;
    // The threshold is a virtual horizontal line on the screen where it
    // considers the "current" header to be above the line. The threshold is
    // modified dynamically to handle headers that are near the bottom of the
    // screen, and to slightly offset the behavior when scrolling up vs down.
    let threshold = defaultDownThreshold;
    // This is used to disable updates while scrolling. This is needed when
    // clicking the header in the sidebar, which triggers a scroll event. It
    // is somewhat finicky to detect when the scroll has finished, so this
    // uses a relatively dumb system of disabling scroll updates for a short
    // time after the click.
    let disableScroll = false;
    // Array of header elements on the page.
    let headers;
    // Array of li elements that are initially collapsed headers in the sidebar.
    // I'm not sure why eslint seems to have a false positive here.
    // eslint-disable-next-line prefer-const
    let headerToggles = [];
    // This is a debugging tool for the threshold which you can enable in the console.
    let thresholdDebug = false;

    // Updates the threshold based on the scroll position.
    function updateThreshold() {
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        const windowHeight = window.innerHeight;
        const documentHeight = document.documentElement.scrollHeight;

        // The number of pixels below the viewport, at most documentHeight.
        // This is used to push the threshold down to the bottom of the page
        // as the user scrolls towards the bottom.
        const pixelsBelow = Math.max(0, documentHeight - (scrollTop + windowHeight));
        // The number of pixels above the viewport, at least defaultDownThreshold.
        // Similar to pixelsBelow, this is used to push the threshold back towards
        // the top when reaching the top of the page.
        const pixelsAbove = Math.max(0, defaultDownThreshold - scrollTop);
        // How much the threshold should be offset once it gets close to the
        // bottom of the page.
        const bottomAdd = Math.max(0, windowHeight - pixelsBelow - defaultDownThreshold);
        let adjustedBottomAdd = bottomAdd;

        // Adjusts bottomAdd for a small document. The calculation above
        // assumes the document is at least twice the windowheight in size. If
        // it is less than that, then bottomAdd needs to be shrunk
        // proportional to the difference in size.
        if (documentHeight < windowHeight * 2) {
            const maxPixelsBelow = documentHeight - windowHeight;
            const t = 1 - pixelsBelow / Math.max(1, maxPixelsBelow);
            const clamp = Math.max(0, Math.min(1, t));
            adjustedBottomAdd *= clamp;
        }

        let scrollingDown = true;
        if (scrollTop < lastKnownScrollPosition) {
            scrollingDown = false;
        }

        if (scrollingDown) {
            // When scrolling down, move the threshold up towards the default
            // downwards threshold position. If near the bottom of the page,
            // adjustedBottomAdd will offset the threshold towards the bottom
            // of the page.
            const amountScrolledDown = scrollTop - lastKnownScrollPosition;
            const adjustedDefault = defaultDownThreshold + adjustedBottomAdd;
            threshold = Math.max(adjustedDefault, threshold - amountScrolledDown);
        } else {
            // When scrolling up, move the threshold down towards the default
            // upwards threshold position. If near the bottom of the page,
            // quickly transition the threshold back up where it normally
            // belongs.
            const amountScrolledUp = lastKnownScrollPosition - scrollTop;
            const adjustedDefault = defaultUpThreshold - pixelsAbove
                + Math.max(0, adjustedBottomAdd - defaultDownThreshold);
            threshold = Math.min(adjustedDefault, threshold + amountScrolledUp);
        }

        if (documentHeight <= windowHeight) {
            threshold = 0;
        }

        if (thresholdDebug) {
            const id = 'mdbook-threshold-debug-data';
            let data = document.getElementById(id);
            if (data === null) {
                data = document.createElement('div');
                data.id = id;
                data.style.cssText = `
                    position: fixed;
                    top: 50px;
                    right: 10px;
                    background-color: 0xeeeeee;
                    z-index: 9999;
                    pointer-events: none;
                `;
                document.body.appendChild(data);
            }
            data.innerHTML = `
                <table>
                  <tr><td>documentHeight</td><td>${documentHeight.toFixed(1)}</td></tr>
                  <tr><td>windowHeight</td><td>${windowHeight.toFixed(1)}</td></tr>
                  <tr><td>scrollTop</td><td>${scrollTop.toFixed(1)}</td></tr>
                  <tr><td>pixelsAbove</td><td>${pixelsAbove.toFixed(1)}</td></tr>
                  <tr><td>pixelsBelow</td><td>${pixelsBelow.toFixed(1)}</td></tr>
                  <tr><td>bottomAdd</td><td>${bottomAdd.toFixed(1)}</td></tr>
                  <tr><td>adjustedBottomAdd</td><td>${adjustedBottomAdd.toFixed(1)}</td></tr>
                  <tr><td>scrollingDown</td><td>${scrollingDown}</td></tr>
                  <tr><td>threshold</td><td>${threshold.toFixed(1)}</td></tr>
                </table>
            `;
            drawDebugLine();
        }

        lastKnownScrollPosition = scrollTop;
    }

    function drawDebugLine() {
        if (!document.body) {
            return;
        }
        const id = 'mdbook-threshold-debug-line';
        const existingLine = document.getElementById(id);
        if (existingLine) {
            existingLine.remove();
        }
        const line = document.createElement('div');
        line.id = id;
        line.style.cssText = `
            position: fixed;
            top: ${threshold}px;
            left: 0;
            width: 100vw;
            height: 2px;
            background-color: red;
            z-index: 9999;
            pointer-events: none;
        `;
        document.body.appendChild(line);
    }

    function mdbookEnableThresholdDebug() {
        thresholdDebug = true;
        updateThreshold();
        drawDebugLine();
    }

    window.mdbookEnableThresholdDebug = mdbookEnableThresholdDebug;

    // Updates which headers in the sidebar should be expanded. If the current
    // header is inside a collapsed group, then it, and all its parents should
    // be expanded.
    function updateHeaderExpanded(currentA) {
        // Add expanded to all header-item li ancestors.
        let current = currentA.parentElement;
        while (current) {
            if (current.tagName === 'LI' && current.classList.contains('header-item')) {
                current.classList.add('expanded');
            }
            current = current.parentElement;
        }
    }

    // Updates which header is marked as the "current" header in the sidebar.
    // This is done with a virtual Y threshold, where headers at or below
    // that line will be considered the current one.
    function updateCurrentHeader() {
        if (!headers || !headers.length) {
            return;
        }

        // Reset the classes, which will be rebuilt below.
        const els = document.getElementsByClassName('current-header');
        for (const el of els) {
            el.classList.remove('current-header');
        }
        for (const toggle of headerToggles) {
            toggle.classList.remove('expanded');
        }

        // Find the last header that is above the threshold.
        let lastHeader = null;
        for (const header of headers) {
            const rect = header.getBoundingClientRect();
            if (rect.top <= threshold) {
                lastHeader = header;
            } else {
                break;
            }
        }
        if (lastHeader === null) {
            lastHeader = headers[0];
            const rect = lastHeader.getBoundingClientRect();
            const windowHeight = window.innerHeight;
            if (rect.top >= windowHeight) {
                return;
            }
        }

        // Get the anchor in the summary.
        const href = '#' + lastHeader.id;
        const a = [...document.querySelectorAll('.header-in-summary')]
            .find(element => element.getAttribute('href') === href);
        if (!a) {
            return;
        }

        a.classList.add('current-header');

        updateHeaderExpanded(a);
    }

    // Updates which header is "current" based on the threshold line.
    function reloadCurrentHeader() {
        if (disableScroll) {
            return;
        }
        updateThreshold();
        updateCurrentHeader();
    }


    // When clicking on a header in the sidebar, this adjusts the threshold so
    // that it is located next to the header. This is so that header becomes
    // "current".
    function headerThresholdClick(event) {
        // See disableScroll description why this is done.
        disableScroll = true;
        setTimeout(() => {
            disableScroll = false;
        }, 100);
        // requestAnimationFrame is used to delay the update of the "current"
        // header until after the scroll is done, and the header is in the new
        // position.
        requestAnimationFrame(() => {
            requestAnimationFrame(() => {
                // Closest is needed because if it has child elements like <code>.
                const a = event.target.closest('a');
                const href = a.getAttribute('href');
                const targetId = href.substring(1);
                const targetElement = document.getElementById(targetId);
                if (targetElement) {
                    threshold = targetElement.getBoundingClientRect().bottom;
                    updateCurrentHeader();
                }
            });
        });
    }

    // Takes the nodes from the given head and copies them over to the
    // destination, along with some filtering.
    function filterHeader(source, dest) {
        const clone = source.cloneNode(true);
        clone.querySelectorAll('mark').forEach(mark => {
            mark.replaceWith(...mark.childNodes);
        });
        dest.append(...clone.childNodes);
    }

    // Scans page for headers and adds them to the sidebar.
    document.addEventListener('DOMContentLoaded', function() {
        const activeSection = document.querySelector('#mdbook-sidebar .active');
        if (activeSection === null) {
            return;
        }

        const main = document.getElementsByTagName('main')[0];
        headers = Array.from(main.querySelectorAll('h2, h3, h4, h5, h6'))
            .filter(h => h.id !== '' && h.children.length && h.children[0].tagName === 'A');

        if (headers.length === 0) {
            return;
        }

        // Build a tree of headers in the sidebar.

        const stack = [];

        const firstLevel = parseInt(headers[0].tagName.charAt(1));
        for (let i = 1; i < firstLevel; i++) {
            const ol = document.createElement('ol');
            ol.classList.add('section');
            if (stack.length > 0) {
                stack[stack.length - 1].ol.appendChild(ol);
            }
            stack.push({level: i + 1, ol: ol});
        }

        // The level where it will start folding deeply nested headers.
        const foldLevel = 3;

        for (let i = 0; i < headers.length; i++) {
            const header = headers[i];
            const level = parseInt(header.tagName.charAt(1));

            const currentLevel = stack[stack.length - 1].level;
            if (level > currentLevel) {
                // Begin nesting to this level.
                for (let nextLevel = currentLevel + 1; nextLevel <= level; nextLevel++) {
                    const ol = document.createElement('ol');
                    ol.classList.add('section');
                    const last = stack[stack.length - 1];
                    const lastChild = last.ol.lastChild;
                    // Handle the case where jumping more than one nesting
                    // level, which doesn't have a list item to place this new
                    // list inside of.
                    if (lastChild) {
                        lastChild.appendChild(ol);
                    } else {
                        last.ol.appendChild(ol);
                    }
                    stack.push({level: nextLevel, ol: ol});
                }
            } else if (level < currentLevel) {
                while (stack.length > 1 && stack[stack.length - 1].level > level) {
                    stack.pop();
                }
            }

            const li = document.createElement('li');
            li.classList.add('header-item');
            li.classList.add('expanded');
            if (level < foldLevel) {
                li.classList.add('expanded');
            }
            const span = document.createElement('span');
            span.classList.add('chapter-link-wrapper');
            const a = document.createElement('a');
            span.appendChild(a);
            a.href = '#' + header.id;
            a.classList.add('header-in-summary');
            filterHeader(header.children[0], a);
            a.addEventListener('click', headerThresholdClick);
            const nextHeader = headers[i + 1];
            if (nextHeader !== undefined) {
                const nextLevel = parseInt(nextHeader.tagName.charAt(1));
                if (nextLevel > level && level >= foldLevel) {
                    const toggle = document.createElement('a');
                    toggle.classList.add('chapter-fold-toggle');
                    toggle.classList.add('header-toggle');
                    toggle.addEventListener('click', () => {
                        li.classList.toggle('expanded');
                    });
                    const toggleDiv = document.createElement('div');
                    toggleDiv.textContent = '❱';
                    toggle.appendChild(toggleDiv);
                    span.appendChild(toggle);
                    headerToggles.push(li);
                }
            }
            li.appendChild(span);

            const currentParent = stack[stack.length - 1];
            currentParent.ol.appendChild(li);
        }

        const onThisPage = document.createElement('div');
        onThisPage.classList.add('on-this-page');
        onThisPage.append(stack[0].ol);
        const activeItemSpan = activeSection.parentElement;
        activeItemSpan.after(onThisPage);
    });

    document.addEventListener('DOMContentLoaded', reloadCurrentHeader);
    document.addEventListener('scroll', reloadCurrentHeader, { passive: true });
})();

