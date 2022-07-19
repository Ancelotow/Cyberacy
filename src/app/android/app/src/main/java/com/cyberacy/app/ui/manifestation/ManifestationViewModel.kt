package com.cyberacy.app.ui.manifestation

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.entities.Manifestation
import com.cyberacy.app.models.repositories.ManifestationDetailState
import com.cyberacy.app.models.repositories.ManifestationRepository
import kotlinx.coroutines.launch

class ManifestationViewModel: ViewModel() {
    private val _manifestation = MutableLiveData<ManifestationDetailState>()
    val manifestation = _manifestation


    init {
        getManifestation()
    }

    fun getManifestation() {
        viewModelScope.launch {
            ManifestationRepository.fetchManifestations().collect {
                _manifestation.value = it
            }
        }
    }

}

