﻿
#Область ПрограммныйИнтерфейс

//Рассчитывает итоговое показатели формы документа "Реализация товаров и услуг".
//
// Параметры:
//	Форма - УправляемаяФорма - форма документа реализации.
//
Процедура РассчитатьИтоговыеПоказателиРеализации(Форма) Экспорт
	
	Форма.СуммаВсего = ?(Форма.Объект.ТребуетсяЗалогЗаТару,
		Форма.Объект.Товары.Итог("СуммаСНДС"),
		Форма.Объект.Товары.Итог("СуммаСНДСБезВозвратнойТары"));
	Форма.СуммаНДС = ?(Форма.Объект.ТребуетсяЗалогЗаТару,
		Форма.Объект.Товары.Итог("СуммаНДС"),
		Форма.Объект.Товары.Итог("СуммаНДСБезВозвратнойТары"));
	Форма.СуммаАвтоСкидки = ?(Форма.Объект.ТребуетсяЗалогЗаТару,
		Форма.Объект.Товары.Итог("СуммаАвтоматическойСкидки"),
		Форма.Объект.Товары.Итог("СуммаАвтоматическойСкидкиБезВозвратнойТары"));
	Форма.СуммаРучнойСкидки = ?(Форма.Объект.ТребуетсяЗалогЗаТару,
		Форма.Объект.Товары.Итог("СуммаРучнойСкидки"),
		Форма.Объект.Товары.Итог("СуммаРучнойСкидкиБезВозвратнойТары"));
	Форма.СуммаСкидки       = Форма.СуммаАвтоСкидки + Форма.СуммаРучнойСкидки;
	
	Форма.СуммаСверхЗаказа = Форма.Объект.Товары.Итог("СуммаСверхЗаказа");

	Если Форма.СуммаВсего > 0 Тогда
		
		Форма.ПроцентАвтоСкидки   = Форма.СуммаАвтоСкидки * 100 / (Форма.СуммаВсего + Форма.СуммаСкидки);
		Форма.ПроцентРучнойСкидки = Форма.СуммаРучнойСкидки * 100 / (Форма.СуммаВсего + Форма.СуммаСкидки);
		Форма.ПроцентСкидки       = Форма.ПроцентАвтоСкидки + Форма.ПроцентРучнойСкидки;
		
	ИначеЕсли Форма.СуммаСкидки > 0 Тогда
		
		Форма.ПроцентАвтоСкидки   = Форма.СуммаАвтоСкидки * 100 / Форма.СуммаСкидки;
		Форма.ПроцентРучнойСкидки = Форма.СуммаРучнойСкидки * 100 / Форма.СуммаСкидки;
		Форма.ПроцентСкидки       = 100;
		
	Иначе
		
		Форма.ПроцентАвтоСкидки   = 0;
		Форма.ПроцентРучнойСкидки = 0;
		Форма.ПроцентСкидки       = 0;
		
	КонецЕсли;
	
	Если Форма.Объект.НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС")
	 Или Форма.Объект.НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД") Тогда
		Форма.Элементы.ГруппаСтраницыВсего.ТекущаяСтраница = Форма.Элементы.СтраницаВсегоБезНДС;
	Иначе
		Форма.Элементы.ГруппаСтраницыВсего.ТекущаяСтраница = Форма.Элементы.СтраницаВсегоСНДС;
	КонецЕсли;
	
КонецПроцедуры

//Обновляет информацию по ТТН
//
// Параметры:
//	Форма - УправляемаяФорма - форма документа реализации.
//	Параметры - Структура - дополнительные параметры.
//
Процедура ОбновитьИнформациюТранспортныхНакладных(Форма, Параметры) Экспорт
	
	Отступ = Новый ФорматированнаяСтрока("  ");
	
	Форма.КоличествоТранспортныхНакладных = Параметры.КоличествоТранспортныхНакладных;
	
	ОформитьТТН = Новый ФорматированнаяСтрока(НСтр("ru='Оформить ТТН'"),,ОбщегоНазначенияВызовСервера.ЦветСтиля("ЦветГиперссылки"),,"СоздатьТранспортнуюНакладную");
	
	Если Форма.КоличествоТранспортныхНакладных = 0 Тогда
		
		Форма.ТекстТТН = Новый ФорматированнаяСтрока(ОформитьТТН);
		
	ИначеЕсли Форма.КоличествоТранспортныхНакладных = 1 Тогда
		
		Накладная = Новый ФорматированнаяСтрока(НСтр("ru='ТТН'") + " " + Параметры.СокращенноеНаименованиеТранспортнойНакладной,,ОбщегоНазначенияВызовСервера.ЦветСтиля("ЦветГиперссылки"),,ПолучитьНавигационнуюСсылку(Параметры.ТранспортнаяНакладная));
		
		// 4D:ERP для Беларуси
		// ЭСЧФ
		// {
		Форма.ТекстТТН = Новый ФорматированнаяСтрока(Накладная, Отступ);
		// }
		// 4D
		
	Иначе
		
		ЗаголовокКоманды = НСтр("ru = 'ТТН (%КоличествоТранспортныхНакладных%)'");
		ЗаголовокКоманды = СтрЗаменить(ЗаголовокКоманды, "%КоличествоТранспортныхНакладных%", Форма.КоличествоТранспортныхНакладных);
		ОткрытьСписокТТН = Новый ФорматированнаяСтрока(ЗаголовокКоманды,,ОбщегоНазначенияВызовСервера.ЦветСтиля("ЦветГиперссылки"),,"ОткрытьСписокТранспортныхНакладных");
		
		// 4D:ERP для Беларуси
		// ЭСЧФ
		// {
		Форма.ТекстТТН = Новый ФорматированнаяСтрока(ОткрытьСписокТТН, Отступ);
		// }
		// 4D
		
	КонецЕсли;
	
	ПродажиКлиентСервер.СформироватьТекстДокументыНаОсновании(Форма);
	
КонецПроцедуры

//Формирует текст документа основания
//
// Параметры:
//	Форма - УправляемаяФорма - форма документа реализации.
//
// Возвращаемое значение:
//   Строка - сформированный текст документа основания.
//
Функция СформироватьТекстДокументыНаОсновании(Форма) Экспорт
	
	Отступ = Новый ФорматированнаяСтрока("    ");
	Форма.ТекстДокументыНаОсновании = Новый ФорматированнаяСтрока(Форма.ТекстСчетФактура,Отступ, Форма.ТекстТТН);
	
	Возврат Форма.ТекстДокументыНаОсновании

КонецФункции

#КонецОбласти




