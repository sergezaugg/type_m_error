# ---------------------------
# Description : text to be used in pages
# Author : Serge Zaugg
# ---------------------------

ptext <- list(
  
  info_expl_datasets_tx = "Inspect a few simulated datasets.
    Each dataset is different due to simlated random error (SD).
    In the full simulation, multiples datasets are generated.
    ",
  
  info_mainti_ti = "Underpowered Research Undermines Science",
  
  info_background_ti = "Background",
  info_background_tx = "
    Research is constrained by competition between researchers
    and the need for fast publication.
    Consequently, researchers are incentivized to conduct studies with smallish sample sizes.
    The declared power (typically 80%) is often
    based on over-optimistic assumptions and the effective power is lower.
    Combined with the selective publication of 'significant' results,
    this increases the Type M error (Magnitude error), i.e. published results overestimate
    the true effect.
    ",
  
  info_thisapp_ti = "This app",
  info_thisapp_tx = "
    With this app, you can simulate the above phenomena using simple but formal
    statistics and assess the severity of the problem.
    ",
  
  info_guide_ti = "Quick guide",
  info_guide_tx = "
    Use the sliders & radio buttons to define the effect strength and sample size.
    In the results pane, see how estimated effect sizes and p-values are related
    and how selective publication based on a fixed α-level biases the pooled evidence.
    The bottom pane shows evidence pooled from all-studies vs. selective publication.
    ",
  
  info_hint_ti = "Hint from author",
  info_hint_tx = "
    Based on my real-world experience as a statistician, I suspect that
    many studies that claim 80% power probably have much less.
    So with this app, try parameter values that give effective power ~50%.
    ",
  
  methods_tx = list(
    p("Each simulation run generates M studies with identical sample sizes and effect sizes, but different random noise."),
    p("'Effect' represents the true or estimated difference in mean values between groups A and B."),
    p("Pooled effects and 95% CIs obtained from a simple fixed-effect meta-analysis"),
    p("'Effective power' is calculated using the known simulation parameters. It is not available in real-world studies."),
    p("In real-world studies, the declared power is based on assumptions made by the researchers.")
  )
  
)

