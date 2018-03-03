﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПараметрыШаблона = ЗначениеНастроекПовтИсп.НастройкиИспользованияСерий(ВидНоменклатуры);
	
	Номер = СокрЛП(Номер);
	
	Если ПараметрыШаблона.ТочностьУказанияСрокаГодностиСерии = Перечисления.ТочностиУказанияСрокаГодности.СТочностьюДоЧасов Тогда
		ГоденДо = НачалоЧаса(ГоденДо);
	Иначе
		ГоденДо = НачалоДня(ГоденДо);
	КонецЕсли;
	
	Наименование = НоменклатураКлиентСервер.ПредставлениеСерии(ПараметрыШаблона, ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыШаблона = ЗначениеНастроекПовтИсп.НастройкиИспользованияСерий(ВидНоменклатуры);

	Если Не ПараметрыШаблона.ИспользоватьНомерСерии Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("Номер");
	КонецЕсли;
	
	Если Не ПараметрыШаблона.ИспользоватьСрокГодностиСерии Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ГоденДо");
	КонецЕсли;
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли