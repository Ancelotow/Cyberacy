package com.esgi.cyberacy

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.ImageView
import android.widget.TextView

class CustomListAdapter(aContext: Context?, listData: List<Country>?) : BaseAdapter() {

    private var listData: List<Country>? = null
    private var layoutInflater: LayoutInflater? = null
    private var context: Context? = null

    init {
        context = aContext
        this.listData = listData
        layoutInflater = LayoutInflater.from(aContext)
    }

    override fun getCount(): Int {
        return listData!!.size
    }

    override fun getItem(position: Int): Any? {
        return listData!![position]
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }


    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View? {
        return null
        // TODO: Why ????
        /*var convertView = convertView
        val holder: ViewHolder
        if (convertView == null) {
            convertView = layoutInflater.inflate(R.layout.list_item_layout, null)
            holder = ViewHolder()
            holder.flagView = convertView!!.findViewById<View>(R.id.imageView_flag) as ImageView?
            holder.countryNameView =
                convertView.findViewById<View>(R.id.textView_countryName) as TextView?
            convertView.setTag(holder)
        } else {
            holder = convertView.tag as ViewHolder
        }
        val country = listData!![position]
        holder.countryNameView.setText(country.getCountryName())
        val imageId = getMipmapResIdByName(country.getFlagName())
        holder.flagView!!.setImageResource(imageId)
        return convertView*/
    }

    // Find Image ID corresponding to the name of the image (in the directory mipmap).
    fun getMipmapResIdByName(resName: String): Int {
        val pkgName = context!!.packageName
        // Return 0 if not found.
        val resID = context!!.resources.getIdentifier(resName, "mipmap", pkgName)
        Log.i("CustomListView", "Res Name: $resName==> Res ID = $resID")
        return resID
    }

    internal class ViewHolder {
        var flagView: ImageView? = null
        var countryNameView: TextView? = null
    }

}