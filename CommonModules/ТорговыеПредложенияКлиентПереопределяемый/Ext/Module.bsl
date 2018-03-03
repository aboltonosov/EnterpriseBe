﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Торговые предложения".
// ОбщийМодуль.ТорговыеПредложенияКлиентПереопределяемый.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработка переопределяемой команды формы.
//
// Параметры:
//  Форма	 - УправляемаяФорма - форма из которой производится обработка команды.
//  Команда	 - КомандаФормы - описание команды формы.
//
Процедура ОбработатьКомандуФормы(Форма, Команда) Экспорт
	
	Если СтрНайти(Команда.Имя, "ВставкаИзБуфера") Тогда
		
		// Вставка из буфера.
		КоличествоТоваровДоВставки = Форма.Список.Количество();

		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("УникальныйИдентификатор", Форма.УникальныйИдентификатор);
		СписокТоваров = ТорговыеПредложенияВызовСервера.ОбработатьПереопределяемыйМетод("ПолучитьСтрокиИзБуфераОбмена", ДополнительныеПараметры);
		
		Для каждого СтрокаТовара Из СписокТоваров Цикл
			ТекущаяСтрока = Форма.Список.Добавить();
			ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара);
		КонецЦикла;
		
		КоличествоВставленных = Форма.Список.Количество() - КоличествоТоваровДоВставки;

		ТекстСообщения = НСтр("ru='Из буфера обмена вставлено строк (%КоличествоВставленных%)'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоВставленных%", КоличествоВставленных);

		ТекстЗаголовка = НСтр("ru='Строки вставлены'");
		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
		
	ИначеЕсли СтрНайти(Команда.Имя, "ПодобратьТовары") Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("УникальныйИдентификатор", Форма.УникальныйИдентификатор);
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ОткрытьФорму("Обработка.ПодборТоваровПоОтбору.Форма", ПараметрыФормы, Форма, Форма.УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейсУП

// Открывает форму поиска торговых предложений по списку товаров.
//
// Параметры:
//  ОписаниеКоманды - Структура - описание команды.
//
Функция ОткрытьПоискТоваровПоСписку(ОписаниеКоманды) Экспорт
	
	ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	ПараметрыВыполненияКоманды = Новый Структура("Источник, Уникальность, Окно, НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("ПараметрыКоманды", ПараметрКоманды);
	
	ОткрытьФорму("Обработка.ТорговыеПредложения.Форма.ПоискПредложенийПоТоварам",
		СтруктураРеквизитов,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецФункции

#КонецОбласти