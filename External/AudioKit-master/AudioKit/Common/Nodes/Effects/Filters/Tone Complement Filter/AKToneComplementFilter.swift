//
//  AKToneComplementFilter.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright (c) 2016 Aurelius Prochazka. All rights reserved.
//

import AVFoundation

/// A complement to the AKLowPassFilter.
///
/// - parameter input: Input node to process
/// - parameter halfPowerPoint: Half-Power Point in Hertz. Half power is defined as peak power / square root of 2.
///
public class AKToneComplementFilter: AKNode, AKToggleable {

    // MARK: - Properties

    internal var internalAU: AKToneComplementFilterAudioUnit?
    internal var token: AUParameterObserverToken?

    private var halfPowerPointParameter: AUParameter?

    /// Ramp Time represents the speed at which parameters are allowed to change
    public var rampTime: Double = AKSettings.rampTime {
        willSet(newValue) {
            if rampTime != newValue {
                internalAU?.rampTime = newValue
                internalAU?.setUpParameterRamp()
            }
        }
    }

    /// Half-Power Point in Hertz. Half power is defined as peak power / square root of 2.
    public var halfPowerPoint: Double = 1000 {
        willSet(newValue) {
            if halfPowerPoint != newValue {
                if internalAU!.isSetUp() {
                    halfPowerPointParameter?.setValue(Float(newValue), originator: token!)
                } else {
                    internalAU?.halfPowerPoint = Float(newValue)
                }
            }
        }
    }

    /// Tells whether the node is processing (ie. started, playing, or active)
    public var isStarted: Bool {
        return internalAU!.isPlaying()
    }

    // MARK: - Initialization

    /// Initialize this filter node
    ///
    /// - parameter input: Input node to process
    /// - parameter halfPowerPoint: Half-Power Point in Hertz. Half power is defined as peak power / square root of 2.
    ///
    public init(
        _ input: AKNode,
        halfPowerPoint: Double = 1000) {

        self.halfPowerPoint = halfPowerPoint

        var description = AudioComponentDescription()
        description.componentType         = kAudioUnitType_Effect
        description.componentSubType      = 0x61746f6e /*'aton'*/
        description.componentManufacturer = 0x41754b74 /*'AuKt'*/
        description.componentFlags        = 0
        description.componentFlagsMask    = 0

        AUAudioUnit.registerSubclass(
            AKToneComplementFilterAudioUnit.self,
            asComponentDescription: description,
            name: "Local AKToneComplementFilter",
            version: UInt32.max)

        super.init()
        AVAudioUnit.instantiateWithComponentDescription(description, options: []) {
            avAudioUnit, error in

            guard let avAudioUnitEffect = avAudioUnit else { return }

            self.avAudioNode = avAudioUnitEffect
            self.internalAU = avAudioUnitEffect.AUAudioUnit as? AKToneComplementFilterAudioUnit

            AudioKit.engine.attachNode(self.avAudioNode)
            input.addConnectionPoint(self)
        }

        guard let tree = internalAU?.parameterTree else { return }

        halfPowerPointParameter = tree.valueForKey("halfPowerPoint") as? AUParameter

        token = tree.tokenByAddingParameterObserver {
            address, value in

            dispatch_async(dispatch_get_main_queue()) {
                if address == self.halfPowerPointParameter!.address {
                    self.halfPowerPoint = Double(value)
                }
            }
        }
        internalAU?.halfPowerPoint = Float(halfPowerPoint)
    }

    // MARK: - Control

    /// Function to start, play, or activate the node, all do the same thing
    public func start() {
        self.internalAU!.start()
    }

    /// Function to stop or bypass the node, both are equivalent
    public func stop() {
        self.internalAU!.stop()
    }
}
