﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПроводкиПоДаннымОперативногоУчета = ПолучитьФункциональнуюОпцию("ФормироватьПроводкиМеждународногоУчетаПоДаннымОперативного");
	ПроводкиПоДаннымРеглУчета = ПолучитьФункциональнуюОпцию("ФормироватьПроводкиМеждународногоУчетаПоДаннымРегламентированного");
	
	Элементы.ГруппаФормированиеПроводокМеждународногоУчетаВложенная1.Видимость = ПроводкиПоДаннымОперативногоУчета;
	Элементы.ГруппаФормированиеПроводокМеждународногоУчетаВложенная2.Видимость = ПроводкиПоДаннымРеглУчета;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИмяТабличнойЧасти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСправочникУчетныеПолитики(Команда)
	ОткрытьФорму("Справочник.УчетныеПолитики.ФормаСписка", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПланСчетовМеждународный(Команда)
	ОткрытьФорму("ПланСчетов.Международный.ФормаСписка", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыСубконто(Команда)
	ОткрытьФорму("ПланВидовХарактеристик.ВидыСубконтоМеждународные.ФормаСписка", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДатуЗапрета(Команда)
	
	ОткрытьФорму("РегистрСведений.ДатыЗапретаФормированияПроводокМеждународныйУчет.Форма.ДатыЗапретаФормирования", , ЭтаФорма);
	
КонецПроцедуры

#Область ГруппыФинансовогоУчета

&НаКлиенте
Процедура ОткрытьСправочникГруппыФинансовогоУчетаДенежныхСредств(Команда)

	ОткрытьФорму("Справочник.ГруппыФинансовогоУчетаДенежныхСредств.ФормаСписка", , ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникТиповыеОперации(Команда)

	ОткрытьФорму("Справочник.ТиповыеОперацииМеждународныйУчет.ФормаСписка", , ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникГруппыФинансовогоУчетаДоходовРасходов(Команда)
	
	ОткрытьФорму("Справочник.ГруппыФинансовогоУчетаДоходовРасходов.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникГруппыФинансовогоУчетаРасчетов(Команда)
	
	ОткрытьФорму("Справочник.ГруппыФинансовогоУчетаРасчетов.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникГруппыФинансовогоУчетаНоменклатуры(Команда)
	
	ОткрытьФорму("Справочник.ГруппыФинансовогоУчетаНоменклатуры.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ФормированиеПроводокМеждународногоУчета

&НаКлиенте
Процедура ОткрытьНастройкуФормированияПроводокПоДаннымОперативногоУчета(Команда)
	
	ОткрытьФорму("Обработка.НастройкаШаблоновПроводокДляМеждународногоУчета.Форма", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуФормированияПроводокПоДаннымРеглУчета(Команда)
	
	ОткрытьФорму("Обработка.НастройкаСоответствияСчетовИОборотовМеждународногоУчета.Форма", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ФинансоваяОтчетность

&НаКлиенте
Процедура ОткрытьСправочникКомплектыФинансовыхОтчетов(Команда)
	
	ОткрытьФорму("Справочник.КомплектыФинансовыхОтчетов.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникВидыФинансовыхОтчетов(Команда)
	
	ОткрытьФорму("Справочник.ВидыФинансовыхОтчетов.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникНемонетарныеПоказателиОтчетов(Команда)
	
	ОткрытьФорму("Справочник.НемонетарныеПоказатели.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОСиНМА

&НаКлиенте
Процедура ОткрытьГруппыНМА(Команда)
	
	ОткрытьФорму("Справочник.ГруппыНМАМеждународныйУчет.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьГруппыОС(Команда)
	
	ОткрытьФорму("Справочник.ГруппыОСМеждународныйУчет.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

#КонецОбласти

#Область Прочее

#КонецОбласти

#КонецОбласти
