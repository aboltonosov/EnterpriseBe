﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ТекущиеДела

// Заполняет список текущих дел пользователя.
// Описание параметров процедуры см. в ТекущиеДелаСлужебный.НоваяТаблицаТекущихДел()
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ИмяФормы = "ЖурналДокументов.ОтчетыКомитентам.Форма.ФормаСпискаДокументов";
	
	ОбщиеПараметрыЗапросов = ТекущиеДелаСлужебный.ОбщиеПараметрыЗапросов();
	
	// Определим доступны ли текущему пользователю показатели группы
	Доступность =
		(ОбщиеПараметрыЗапросов.ЭтоПолноправныйПользователь
			Или ПравоДоступа("Просмотр", Метаданные.Документы.ОтчетКомитенту))
		И (ПравоДоступа("Добавление", Метаданные.Документы.ОтчетКомитенту)
			ИЛИ ПравоДоступа("Добавление", Метаданные.Документы.ОтчетКомитентуОСписании))
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКОформлениюОтчетовКомитенту)
		И ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриЗакупках");
		
	Если НЕ Доступность Тогда
		Возврат;
	КонецЕсли;
	
	// Расчет показателей
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СУММА(ВложенныйЗапрос.КоличествоДокументов) КАК ОтчетыКомитентамТребуетсяОформить
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВложенныйЗапрос.ПериодСписания КАК ПериодСписания,
	|		ВложенныйЗапрос.Валюта КАК Валюта,
	|		ВложенныйЗапрос.Организация КАК Организация,
	|		ВложенныйЗапрос.Комитент КАК Комитент,
	|		ВложенныйЗапрос.Соглашение КАК Соглашение,
	|		ВложенныйЗапрос.Договор КАК Договор,
	|		ВложенныйЗапрос.НалогообложениеНДС КАК НалогообложениеНДС,
	|		1 КАК КоличествоДокументов
	|	ИЗ
	|		(ВЫБРАТЬ
	|			NULL КАК ПериодСписания,
	|			ТоварыКОформлению.Валюта КАК Валюта,
	|			ТоварыКОформлению.ВидЗапасов.Организация КАК Организация,
	|			ТоварыКОформлению.ВидЗапасов.Комитент КАК Комитент,
	|			ТоварыКОформлению.ВидЗапасов.Соглашение КАК Соглашение,
	|			ТоварыКОформлению.ВидЗапасов.Договор КАК Договор,
	|			ТоварыКОформлению.ВидЗапасов.НалогообложениеНДС КАК НалогообложениеНДС,
	|			NULL КАК КоличествоСписано
	|		ИЗ
	|			РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту.Остатки(, ) КАК ТоварыКОформлению
	|		ГДЕ
	|			ТоварыКОформлению.ВидЗапасов.Комитент ССЫЛКА Справочник.Партнеры
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ТоварыКОформлению.Валюта,
	|			ТоварыКОформлению.ВидЗапасов.Организация,
	|			ТоварыКОформлению.ВидЗапасов.Комитент,
	|			ТоварыКОформлению.ВидЗапасов.Соглашение,
	|			ТоварыКОформлению.ВидЗапасов.Договор,
	|			ТоварыКОформлению.ВидЗапасов.НалогообложениеНДС
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			NULL,
	|			УслугиКОформлению.Валюта,
	|			УслугиКОформлению.Организация,
	|			Партнер.Ссылка,
	|			УслугиКОформлению.Соглашение,
	|			НЕОПРЕДЕЛЕНО,
	|			НЕОПРЕДЕЛЕНО,
	|			NULL
	|		ИЗ
	|			РегистрНакопления.УслугиКОформлениюОтчетовПринципалу.Остатки(, ) КАК УслугиКОформлению
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнер
	|				ПО УслугиКОформлению.АналитикаУчетаНоменклатуры.Склад = Партнер.Ссылка
	|		ГДЕ
	|			УслугиКОформлению.АналитикаУчетаНоменклатуры.Склад ССЫЛКА Справочник.Партнеры
	|		
	|		СГРУППИРОВАТЬ ПО
	|			УслугиКОформлению.Валюта,
	|			УслугиКОформлению.Организация,
	|			Партнер.Ссылка,
	|			УслугиКОформлению.Соглашение
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			Обороты.ПериодМесяц,
	|			Обороты.Валюта,
	|			Обороты.ВидЗапасов.Организация,
	|			Обороты.ВидЗапасов.Комитент,
	|			Обороты.ВидЗапасов.Соглашение,
	|			Обороты.ВидЗапасов.Договор,
	|			Обороты.ВидЗапасов.НалогообложениеНДС,
	|			СУММА(Обороты.КоличествоСписаноПриход) - СУММА(Обороты.КоличествоСписаноРасход)
	|		ИЗ
	|			РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту.Обороты(, , Авто, ) КАК Обороты
	|		ГДЕ
	|			Обороты.ВидЗапасов.Комитент ССЫЛКА Справочник.Партнеры
	|		
	|		СГРУППИРОВАТЬ ПО
	|			Обороты.ПериодМесяц,
	|			Обороты.Валюта,
	|			Обороты.ВидЗапасов.Организация,
	|			Обороты.ВидЗапасов.Комитент,
	|			Обороты.ВидЗапасов.Соглашение,
	|			Обороты.ВидЗапасов.Договор,
	|			Обороты.ВидЗапасов.НалогообложениеНДС
	|		
	|		ИМЕЮЩИЕ
	|			СУММА(Обороты.КоличествоСписаноПриход) - СУММА(Обороты.КоличествоСписаноРасход) <> 0) КАК ВложенныйЗапрос
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ВложенныйЗапрос.ПериодСписания,
	|		ВложенныйЗапрос.Валюта,
	|		ВложенныйЗапрос.Организация,
	|		ВложенныйЗапрос.Комитент,
	|		ВложенныйЗапрос.Соглашение,
	|		ВложенныйЗапрос.Договор,
	|		ВложенныйЗапрос.НалогообложениеНДС) КАК ВложенныйЗапрос";
	
	Результат = ТекущиеДелаСлужебный.ЧисловыеПоказателиТекущихДел(Запрос, ОбщиеПараметрыЗапросов);
	
	// Заполнение дел.
	// ОтчетыКомиссионеров
	ДелоРодитель = ТекущиеДела.Добавить();
	ДелоРодитель.Идентификатор  = "ОтчетыКомитентам";
	ДелоРодитель.Представление  = НСтр("ru = 'Отчеты комитентам'");
	ДелоРодитель.ЕстьДела       = Результат.ОтчетыКомитентамТребуетсяОформить > 0;
	ДелоРодитель.Владелец       = Метаданные.Подсистемы.Закупки;
	
	// ОтчетыКомитентамТребуетсяОформить
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Комитент", Справочники.Партнеры.ПустаяСсылка());
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СтруктураБыстрогоОтбора", ПараметрыОтбора);
	ПараметрыФормы.Вставить("ИмяТекущейСтраницы", "СтраницаРаспоряженияНаОформление");
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ОтчетыКомитентамТребуетсяОформить";
	Дело.ЕстьДела       = Результат.ОтчетыКомитентамТребуетсяОформить > 0;
	Дело.Представление  = НСтр("ru = 'Требуется оформить'");
	Дело.Количество     = Результат.ОтчетыКомитентамТребуетсяОформить;
	Дело.Важное         = Ложь;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = ПараметрыФормы;
	Дело.Владелец       = "ОтчетыКомитентам";
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
